module TravelAdmin
  class SchedulesController < ResourceController
    def title
      if action_name == 'show'
        @title = 'Seats table'
      else
       super
      end 
    end 
    def generate
      @today = Date.today
      @default_days = cfg.get_config(:max_reservation_days).to_i
      @messages = []

      if params[:tour]
        @log_brief = "Generate schedules"
        @log_text = "Tour: #{params[:tour]}\nSchedules: #{params[:ids]}"
        @log_level = 3
        tour = Tour.find(params[:tour])
        params[:ids].split(',').each do |day|
          tour.gen_schedule(day.to_date)
        end
        render :text => params[:tour] + ' done '
      else
        @log_brief = 'Prepare to Generate schedules.'
        @log_text = ''
        @log_level = 2
        Tour.where(:status => 1).each do |tour|
          gen_tour_schedule(tour, false)
        end
      end
    end
    
    def gen_tour_schedule(tour, gen_schedule)
      if tour.ready_to_gen?
        tour_days = []
        days = tour.tour_setting.days_in_advance.to_i
        days = @default_days if days == 0
        (@today..@today + days).each do |day|
          tour_days << day 
        end
        if tour_days.length > 0
          ds = []
          tour_days.each do |d|
            range = d..d+1
            if !Schedule.exists?(:tour_id => tour.id, :departure_date => range)            
              ds << d
            end
          end
          @messages << [tour.id, tour.description.title, ds] if ds.count > 0
        end
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
