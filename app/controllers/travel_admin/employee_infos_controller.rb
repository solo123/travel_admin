module TravelAdmin
	class EmployeeInfosController < ResourceController
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
    def test_email
      UserMailer.test_email(current_employee.employee_info).deliver
      flash[:notice] = "Welcome email sent to #{current_employee.employee_info.default_email}."
      redirect_to :controller => 'admin/employees', :action => :index
    end
    def set_psw
    end

    private
    def employee_info_params
      params.require(:employee_info).permit(:company_id, :nickname, :telephone, :email, :address)
    end
	end
end
