module TravelAdmin
  class PayMethodsController < ResourceController
    def new
      @order = Order.find(params[:order_id])
      @object = object_name.classify.constantize.new
    end
    def create
		  params.permit!
      @order = Order.find(params[:order_id])
      @object = object_name.classify.constantize.new(params[object_name.singularize.parameterize('_')])
      order = Order.find(params[:order_id])
      biz_payment = Biz::OrderPayment.new
      if @object.is_a? RefundCash
        biz_payment.refund(order, @object, current_employee.employee_info)
      else
        biz_payment.pay(order, @object, current_employee.employee_info) 
      end
      unless biz_payment.errors.blank? 
        flash[:error] = biz_payment.errors.to_sentence
        @no_log = 1
      end
      @order.reload
    end
  end
end


