module TravelAdmin
  class SchedulesController < ResourceController
    def title
      if action_name == 'show'
        @title = 'Seats table'
      else
        super
      end 
    end 

    def orders
      load_object
    end
    def selected
      @object = Schedule.where(:tour_id => params[:tour_id]).where(:departure_date => params[:departure_date]).first
      if params[:page] == 'order'
        render 'admin/orders/selected'
      else
        render :text => @object ? "set_schedule(#{@object.id});" : "alert('not found');"
      end
    end

    #override index
    def index
      @tt = 1
      @tt = params[:tour_type] if params[:tour_type]
      params[:q] ||= {:departure_date_gteq => Date.current()}
      @q = Schedule.joins(:tour).where(['tours.tour_type = ?', @tt]).search(params[:q])
      pages = $redis.get(:admin_list_per_page).to_i
      @collection = @q.result.page(params[:page]).per_page(pages)
    end
    #override create
    def create
      tour = Tour.find(params[:tour_id])
      @object = tour.schedules.where(:departure_date => params[:departure_date]).first
      if @object
        flash[:error] = "Schedule #{@object.id} Already existed."
      else
        @object = tour.add_schedule(Date.parse(params[:departure_date]))
        if @object
          flash[:notice] = "Add new Schedule #{@object.id}"
        else
          flash[:error] = 'Add schedule error!'
        end
      end
    end
    def show
      @object = Schedule.find(params[:id])
      if @object.assignments.length > 0
        redirect_to schedule_schedule_assignment_path(@object, @object.assignments.first)
        return
      end
    end

  end
end
