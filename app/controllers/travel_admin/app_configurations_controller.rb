module TravelAdmin
	class AppConfigurationsController < ResourceController
    def reload
      cfg.reload
      redirect_to :action => :index
    end
	end
end

