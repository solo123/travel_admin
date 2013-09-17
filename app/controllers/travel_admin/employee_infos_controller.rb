module TravelAdmin
	class EmployeeInfosController < ResourceController
		def index
      @q = EmployeeInfo.search(params[:q])
      @ecs = EmployeeInfo.select('company_id, count(*) as count').where(:status => 1).group(:company_id).includes(:company)
      @cid = 0
      if params[:c]
        @cid = params[:c].to_i
      else
        @cid = @ecs.first.company_id
      end
      @employee_infos = EmployeeInfo.where(:company_id => @cid).where(:status => 1) 
		end
    def docs
      @ecs = EmployeeInfo.select('company_id, count(*) as count').where(:status => 1).group(:company_id).includes(:company)
      @cid = 0
      @btn_css = ['btn', 'btn', 'btn']
      if params[:c]
        @cid = params[:c].to_i
      else
        @cid = @ecs.first.company_id
      end
      if params[:s] && params[:s] == 'hide'
        @btn_css[1] = 'btn btn-info disabled'
        @employee_infos = EmployeeInfo.where(:company_id => @cid).where(:status => 0)
      elsif params[:s] && params[:s] == 'del'
        @btn_css[2] = 'btn btn-info disabled'
        @employee_infos = EmployeeInfo.where(:company_id => @cid).where('status > 1')
      else
        @btn_css[0] = 'btn btn-info disabled'
        @employee_infos = EmployeeInfo.where(:company_id => @cid).where(:status => 1) 
      end
      @employee_infos = @employee_infos.order('id desc')
    end
    def search
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
    def create
      @object = EmployeeInfo.new(params[:employee_info])
      @object.status = 1
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
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
    def destroy
      load_object
      if @object.status == 1
        @object.status = 0
      else
        @object.status = 7
      end
      @object.save
    end
    def set_psw
    end
	end
end
