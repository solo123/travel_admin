module TravelAdmin
	class LogsController < AdminController
    def initialize
      super
      @no_log = '1'
    end
    def index
      params[:search] ||= {}
      @search = Log.metasearch(params[:search])
      @collection = @search.page(params[:page]).per_page(cfg.get_config(:admin_list_per_page))
    end
    def show
      @object = Log.find(params[:id])
    end
	end
end
