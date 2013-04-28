module Biz
  class OrderPayment
    attr_reader :errors

    def pay(order, a_pay, operator)
      @errors = []
      check_for_pay(order, a_pay, operator)
      return unless @errors.blank?

      payment = set_payment_data(order, a_pay, operator)
      ActiveRecord::Base.transaction do
        set_receive_account(payment)      
        payment.save!
        payment.account.save!
        order.pay(payment)
        a_pay.status = 8
        a_pay.save
        if a_pay.is_a? PayVoucher
          a_pay.voucher.status = 0
          a_pay.voucher.save!
        end
      end
    end
    def check_for_pay(order, a_pay, operator)
      @errors = []
      unless operator.is_a? EmployeeInfo
        @errors << "Please Login befor payment"
        return
      end
      unless order.ready_to_payment?
        @errors << "Order is not ready to payment."
        return
      end
      unless a_pay.amount > 0
        @errors << "Please input pay amount."
        return
      end
      unless a_pay.valid?
        @errors << a_pay.errors.full_messages.to_sentence
        return
      end
      if (a_pay.is_a? PayCash) || (a_pay.is_a? PayCheck)
        unless a_pay.received_by
          @errors << "Please select received by"
          return
        end
        a_pay.account = get_employee_account(a_pay.received_by, a_pay.class.name)
      elsif (a_pay.is_a? PayCompany)
        a_pay.account_receivable = a_pay.amount - a_pay.company_discount - a_pay.additional_discount
        a_pay.account = get_company_account(a_pay.company, 'PayCompany')
      else
        a_pay.account = get_company_account(operator.company, a_pay.class.name)
      end
      @errors << "Account not found" unless a_pay.account
    end

    def set_payment_data(order, a_pay, operator)
      p = a_pay.build_payment
      p.payment_data = order
      p.pay_method = a_pay
      p.account = a_pay.account
      p.operator = operator
      p.amount = a_pay.amount
      p.pay_from = order.order_detail.user_info
      a_pay.payment = p
      a_pay.status = 1
      p
    end
    def set_receive_account(payment)
      account = payment.account
      acc_hist = account.account_histories.build
      acc_hist.add_balance(account.balance, payment.amount)
      account.balance = acc_hist.balance_after
      acc_hist.payment = payment
    end

    def refund(order, a_refund, operator)
      check_for_refund(order, a_refund, operator)
      return unless @errors.blank?

      payment = set_payment_data(order, a_refund, operator)
      ActiveRecord::Base.transaction do
        set_receive_account(payment)
        payment.save!
        payment.account.save!
        order.pay(payment)
        a_refund.status = 8
        a_refund.save
      end
    end

    def check_for_refund(order, refund, operator)
      @errors = []
      unless operator.is_a? EmployeeInfo
        @errors << "Please Login befor refund"
        return
      end
      unless order.status && order.status > 1 && order.order_price && order.order_price.balance_amount < order.order_price.actual_amount
        @errors << "Order is not ready to refund."
        return
      end
      unless refund.amount < 0
        @errors << "Please input pay amount."
        return
      end
      unless refund.valid?
        @errors << refund.errors.full_messages.to_sentence
        return
      end
      if refund.is_a? RefundCash
        unless refund.received_by
          @errors << "Please select refund from"
          return
        end
        refund.account = get_employee_account(refund.received_by, 'PayCash')
      end
      @errors << "Account not found" unless refund.account
    end

    def cancel_order(order, operator)
      # new order
      if !order.status || order.status == 0
        order.status = 7
        order.save
        return
      end

      check_for_cancel(order, operator)
      return unless @errors.blank?

      # order no pay
      if order.order_price.actual_amount == order.order_price.balance_amount
        order.status = 7
        order.save
        return
      end

      # create voucher and cancel
      voucher = Voucher.new
      voucher.order = order
      voucher.amount = order.order_price.actual_amount - order.order_price.balance
      voucher.expire_date = Date.today + 1.year 
      voucher.status = 1
      p = voucher.build_payment
      p.payment_data = order
      p.amount = 0 - voucher.amount
      p.account = get_company_account(operator.company, 'Voucher')
      p.pay_method = voucher
      p.operator_id = operator.id
      unless p.account
        errors << "Company Voucher account not found"
        return
      end

      ActiveRecord::Base.transaction do
        voucher.save
        order_hist = order.account_histories.build
        order_hist.sub_balance(order.order_price.balance_amount, p.amount)
        order.order_price.balance_amount = order_hist.balance_after
        order_hist.payment = p

        account = p.account
        acc_hist = account.account_histories.build
        acc_hist.add_balance(account.balance, p.amount)
        account.balance = acc_hist.balance_after
        acc_hist.payment = p

        unless p.save
          errors << p.errors.full_messages.to_sentence
          break
        end
        unless account.save
          errors << account.errors.full_messages.to_sentence
          break
        end
        order.status = 7
        unless order.save
          errors << order.errors.full_messages.to_sentence
          break
        end
      end
    end
    def check_for_cancel(order, operator)
      @errors = []
      unless operator.is_a? EmployeeInfo
        @errors << "Please Login befor refund"
        return
      end
      unless operator.company
        @errors << "Operator have no company"
        return
      end
      unless order
        @errors << "Cannot cancle without order"
        return
      end
      unless order.status && order.status > 1 && order.order_price && order.order_price.balance_amount <= order.order_price.actual_amount
        @errors << "Order is not ready to refund."
        return
      end
      if order.voucher
        @errors << "Order already have a voucher"
        return
      end
    end
    def withdraw(a_pay, operator)
      check_for_withdraw(a_pay, operator)
      return unless @errors.blank?
      
      p_old = a_pay.payment
      payment = Payment.new
      payment.payment_data = p_old.payment_data
      payment.amount = 0 - p_old.amount
      payment.pay_from = p_old.pay_from
      payment.account = p_old.account
      payment.operator = operator

      w_pay = a_pay.dup
      w_pay.amount = 0 - a_pay.amount
      w_pay.status = 0
      w_pay.payment = payment
      payment.pay_method = w_pay

      ActiveRecord::Base.transaction do
        account = payment.account
        acc_hist = account.account_histories.build
        acc_hist.add_balance(account.balance, payment.amount)
        account.balance = acc_hist.balance_after
        acc_hist.payment = payment

        payment.save!
        account.save!
        payment.payment_data.pay(payment)
        w_pay.status = 7
        w_pay.save!
        a_pay.status = 7
        a_pay.save!
      end
    end
    def check_for_withdraw(a_pay, operator)
      @errors = []
      unless operator.is_a? EmployeeInfo
        errors << "Please Login"
        return
      end
      unless (a_pay.is_a? PayCreditCard) || (a_pay.is_a? PayCheck) || (a_pay.is_a? PayVoucher)
        errors << "Only credit card and check and voucher can withdraw"
        return
      end
=begin      
      unless a_pay.status == 1
        errors << "This item cannot withdraw."
        return
      end
=end
      order = a_pay.payment.payment_data
      unless order.status && order.status > 0 && order.status != 7
        errors << "Order cannot withdraw."
        return
      end
      unless a_pay.amount > 0
        errors << "Cannot withdraw amount 0."
        return
      end
      if a_pay.new_record?
        errors << "cannot withdraw this item."
        return
      end
      unless a_pay.account
        errors << "Account not found"
        return
      end
    end
    def set_order_and_history(order, payment, withdraw_pay)
    end

    def get_employee_account(employee_info, pay_method)
      acc = employee_info.accounts.where(:account_type => pay_method).first
      unless acc
        acc = employee_info.accounts.build(:account_type => pay_method, :balance => 0)
        acc.save
      end
      acc
    end
    def get_company_account(company, account_type)
      return nil unless company
      acc = company.accounts.where(:account_type => account_type).first
      unless acc
        acc = company.accounts.build(:account_type => account_type, :balance => 0)
        acc.save
      end
      acc
    end

    def caculate_price(order)
      return unless order
      return unless order.schedule
      schedule = order.schedule
      order.build_order_price unless order.order_price
      order.order_items.each do |item|
        item.num_total = item.num_adult + item.num_child
        if item.num_total > 0 && item.num_total <= 4
          item.amount = eval("schedule.price.price#{item.num_total}")
        else
          item.amount = 0
        end
        item.save
      end
      op = order.order_price
      op.num_rooms = order.order_items.count
      op.num_total = order.order_items.sum(:num_total)
      op.total_amount = order.order_items.sum(:amount)
      op.actual_amount = op.total_amount + op.adjustment_amount
      op.balance_amount = op.total_amount + op.adjustment_amount - op.payment_amount
      op.save
    end

  end
end
