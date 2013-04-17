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
      render :partial => 'orders', :object => @object.orders
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
      return @collection if @collection
      params[:search] ||= {:departure_date_greater_than_or_equal_to => Date.current()}
      @search = Schedule.metasearch(params[:search])
      @collection = @search.page(params[:page]).per_page(cfg.get_config(:admin_list_per_page))
    end
    #override create
    def create
      tour = Tour.find(params[:tour_id])
      @object = tour.schedules.where(:departure_date => params[:departure_date]).first
      if @object
        flash[:error] = "Schedule #{@object.id} Already existed."
      else
        @object = tour.gen_schedule(Date.parse(params[:departure_date]))
        flash[:notice] = "Add new Schedule #{@object.id}"
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
