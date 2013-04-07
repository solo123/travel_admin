module TravelAdmin
	class MyLogsController < AdminController
    layout nil
    layout 'admin', :except => :zone
    def initialize
      super
      @no_log = '1'
    end
    def index
      params[:search] ||= {}
      @search = Log.metasearch(params[:search])
      @collection = @search.page(params[:page]).per_page(cfg.get_config(:admin_list_per_page))
    end
    def zone
      @collection ||= Log.last_operations(current_employee)
    end
	end
end

