module TravelAdmin
	class EmployeesController < ResourceController
    def new
      load_parent
      @object = @employee_info.build_employee
    end
    def create
      load_parent
      @object = @employee_info.build_employee
      @object.update_attributes(params[:employee])
      unless @object.save && @employee_info.save
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
    protected
    def load_object
      load_parent
      @object = Employee.find(params[:id])
    end
    def load_parent
      @employee_info = EmployeeInfo.find(params[:employee_info_id]) if params[:employee_info_id]
    end
	end
end
