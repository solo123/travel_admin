module TravelAdmin
	class TodosController < ResourceController
    layout nil
    layout 'admin', :except => :zone
    def create
      @object = Todo.new(params[:todo])
      @object.employee_info = current_employee.employee_info
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
      end
    end
    def zone
      @no_log = 1
      @collection = Todo.where(:employee_info_id => current_employee.id).order('level desc, due_date desc').limit(10)
    end
    def add_employee
      @object = Todo.find(params[:id])
      @worker = @object.todo_workers.build
    end
    def add_worker
      @object = Todo.find(params[:id])
      @worker = @object.todo_workers.build
      @worker.update_attributes(params[:todo_worker])
    end
    def rm_worker
      @worker = TodoWorker.find(params[:wid])
      @worker.destroy
      @object = Todo.find(params[:id])
    end
	end
end

