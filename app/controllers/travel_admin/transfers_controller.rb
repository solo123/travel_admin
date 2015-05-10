module TravelAdmin
  class TransfersController < ResourceController
    def create
		  params.permit!
      @object = Transfer.new(params[:transfer])
			@object.employee_info = current_employee.employee_info
			biz = Biz::OrderPayment.new
			biz.do_transfer(@object, current_employee.employee_info)
			
			respond_to do |format|
        format.html { redirect_to action: :index }
				format.js
			end
    end
	end
end

