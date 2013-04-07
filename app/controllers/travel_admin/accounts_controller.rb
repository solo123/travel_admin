module TravelAdmin
	class AccountsController < ResourceController
    def new
      load_parent
      @object = @parent.accounts.build
      @object.account_brief ||= @parent.show_name
    end
    def create
      load_parent
      @object = @parent.accounts.build(params[:account])
      @object.status = 1
      unless @object.save
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
    def load_parent
      @parent = if params[:employee_info_id]
                  EmployeeInfo.find(params[:employee_info_id])
                elsif params[:company_id]
                  Company.find(params[:company_id])
                end
    end
    def company
       load_collection 
    end
    def pay
      load_object
    end
	end
end

