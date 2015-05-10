module TravelAdmin
  class RemarksController < ResourceController
    def new
      load_parent
      @object = @parent.remarks.build
    end
    def create
		  params.permit!
      load_parent
      @object = @parent.remarks.build(params[:remark])
      @object.employee_info = current_employee.employee_info
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
      end
    end

    protected
    def load_collection
      load_parent
      @collection = @parent.remarks if @parent
    end
    def load_object
      load_parent
      @object = Remark.find(params[:id])
    end
    def load_parent
      @parent = if params[:todo_id]
                  Todo.find(params[:todo_id])
                elsif params[:order_id]
                  Order.find(params[:order_id])
                end
    end
  end
end
