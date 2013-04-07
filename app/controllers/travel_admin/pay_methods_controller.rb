module TravelAdmin
  class PayMethodsController < ResourceController
    def create
      order = Order.find(params[:order_id])
      biz_payment = Biz::OrderPayment.new
      if params[:commit] == 'refund'
        biz_payment.refund(order, @object, current_employee.employee_info)
      else
        biz_payment.pay(order, @object, current_employee.employee_info) 
      end
      unless biz_payment.errors.blank? 
        flash[:error] = biz_payment.errors.to_sentence
        @no_log = 1
      end
    end
  end
end


