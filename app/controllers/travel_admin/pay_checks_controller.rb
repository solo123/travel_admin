module TravelAdmin
  class PayChecksController < PayMethodsController
    def destroy
      @object = PayCheck.find(params[:id])
      biz = Biz::OrderPayment.new
      biz.withdraw(@object, current_employee.employee_info)
      unless biz.errors.blank?
        flash[:error] = biz.errors.to_sentence
        @log_text = "withdraw check error: " + biz.errors.to_sentence
      end
    end
  end
end


