module TravelAdmin
  class OrdersController < ResourceController
    def create
      @object = Order.new
      @object.schedule_assignment = ScheduleAssignment.find(params[:assignment_id])
      @object.schedule = @object.schedule_assignment.schedule
      @object.save
      set_seats
      biz = Biz::OrderPayment.new
      biz.caculate_price(@object)
      redirect_to order_path(@object)
    end
    def update
      load_object
      @object.attributes = params[:order]
      if @object.changed_for_autosave?
        @changes = @object.all_changes
        if @object.save
          biz = Biz::OrderPayment.new
          biz.caculate_price(@object)
        else
          flash[:error] = @object.errors.full_messages.to_sentence
          @no_log = 1
        end
      end
    end
    def show
      load_object
      @order = @object
    end
    def destroy
      load_object
      biz = Biz::OrderPayment.new
      biz.cancel_order(@object, current_employee.employee_info)
      unless biz.errors.blank?
        flash[:error] = biz.errors.to_sentence
      end
    end
    private
    def set_seats
      unless params[:seats].blank?
        @object.set_seats(params[:seats])
      end
    end
  end
end
