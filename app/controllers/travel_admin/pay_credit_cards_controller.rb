module TravelAdmin
  class PayCreditCardsController < PayMethodsController
    def create
      @object = PayCreditCard.new(params[:pay_credit_card])
      super
    end
    def destroy
      @object.PayCreditCard.find(params[:id])
      biz_payment = Biz::OrderPayment.new
    end
    def look
      @object = PayCreditCard.find(params[:id])
      order = @object.order
      biz_payment = Biz::OrderPayment.new
      biz_payment.pay(order, @object, current_employee.employee_info) 
      unless biz_payment.errors.blank? 
        flash[:error] = biz_payment.errors.to_sentence
        @no_log = 1
      end
      redirect_to @object
    end
  end
end


