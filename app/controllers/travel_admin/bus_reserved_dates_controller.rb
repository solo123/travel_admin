module TravelAdmin
	class BusReservedDatesController < ResourceController

    def index
      load_collection
    end
  def new
    @parent = Bus.find(params[:bus_id]) if params[:bus_id]
    @object = @parent.bus_reserved_dates.build
  end
  def create
    @parent = Bus.find(params[:bus_id])
    @object = @parent.bus_reserved_dates.build(params[:bus_reserved_date])
    @object.save
  end
    protected
    def load_collection
      @parent = Bus.find(params[:bus_id]) if params[:bus_id]
      @collection = @parent.bus_reserved_dates if @parent
    end
    def load_object
      @parent = Bus.find(params[:bus_id]) if params[:bus_id]
      @object = BusReservedDate.find(params[:id])
    end
	end
end

