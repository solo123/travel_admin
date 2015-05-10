module TravelAdmin
	class AppConfigurationsController < AdminController
    def index
      @keys = %w(admin_path website_name admin_list_per_page max_reservation_days)
    end
    def create
      $redis.set(params[:name], params[:value])
    end
	end
end
