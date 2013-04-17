module TravelAdmin
  class OrdersController < ResourceController
    def new
      @object = Order.new
      new_params
    end
    def create
      @object = Order.new(params[:order])
      @object.recaculate_price
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
      set_seats
    end
    def show
      load_object
      @order = @object
    end
    private
    def new_params
      if !@object.schedule_assignment && params[:assignment_id]
        sa = ScheduleAssignment.find(params[:assignment_id])
        @object.schedule_assignment = sa
        @object.schedule = sa.schedule
      end

      if params[:seats]
        rn = params[:seats].split(',').count
        while rn > 0 do
          item = @object.order_items.build
          item.num_adult = rn > 2 ? 2 : rn
          rn = rn - 2
        end
      end
    end
    def set_seats
      unless params[:seats].blank?
        @object.set_seats(params[:seats])
      end
    end
  end
end
