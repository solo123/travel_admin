module TravelAdmin
	class EmployeeInfosController < ResourceController
    def docs
      unless has_auth('view_employee_document')
        flash[:error] = 'Unauthorised access to special page.'
        redirect_to :controller => 'admin/home', :action => :index 
      else
        load_collection
      end
    end
    def test_email
      UserMailer.test_email(current_employee.employee_info).deliver
      flash[:notice] = "Welcome email sent to #{current_employee.employee_info.default_email}."
      redirect_to :controller => 'admin/employees', :action => :index
    end
    def edit_info
      load_object
    end
    def update
      load_object
      @object.attributes = params[:employee_info]
      @object.roles = params[:role].collect { |r| r[0] }.join() if params[:role]
      if @object.changed_for_autosave?
        @changes = @object.all_changes
        unless @object.save
          flash[:error] = @object.errors.full_messages.to_sentence
          @no_log = 1
        end
      end
      render 'update_info'
    end
	end
end
