module TravelAdmin
  class BusesController < ResourceController
    def shift
      @bus = Bus.find(params[:id])
    end

    private
    def bus_params
      params.require(:bus).permit(:name, :bus_type, :seats, :seats_per_row, :passengeway, :reserved_seats, :company_id, :contact_name, :tel, :plate_number, :vin_number, :inspection_date)
    end
  end
end
