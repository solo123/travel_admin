module TravelAdmin
  class DestinationsController < ResourceController
    def show
      load_object
    end

    protected
    def load_collection
      #params[:search] ||= {}
      @search = Destination.search(params[:q])
      pages = cfg.get_config(:admin_list_per_page) || "20"
      @collection = @search.result.paginate(:page => params[:page], :per_page => pages).includes([:city])
    end

  end
end
