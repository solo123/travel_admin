module TravelAdmin
	class VouchersController < PayMethodsController
    def create
      @object = Voucher.new(params[:voucher])
      order = Order.find(params[:order_id])
      @object.order = order
      biz_payment = Biz::OrderPayment.new
      biz_payment.cancle_to_voucher(@object, current_employee.employee_info)
      unless biz_payment.errors.blank? 
        flash[:error] = biz_payment.errors.to_sentence
        @no_log = 1
      end
    end
	end
end
