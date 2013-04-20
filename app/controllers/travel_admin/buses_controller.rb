module TravelAdmin
  class BusesController < ResourceController
    def shift
      @bus = Bus.find(params[:id])
    end
  end
end
