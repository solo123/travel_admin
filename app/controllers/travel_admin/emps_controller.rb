module TravelAdmin
	class EmpsController < AdminController
		def index
      @search = EmployeeInfo.metasearch(params[:search])
      @ecs = EmployeeInfo.select(:company_id).where('company_id>0').uniq.includes(:company)
      @cid = 0
      if params[:company_id]
        @cid = params[:company_id].to_i
      else
        @cid = @ecs.first.company_id
      end
      @employee_infos = EmployeeInfo.where(:company_id => @cid).where(:status => 1) 
		end
	end
end

