module TravelAdmin
  class BusesController < ResourceController
    def shift
      @bus = Bus.find(params[:id])
      @year = Date.today.year
      @year = params[:year].to_i if params[:year]
      d_start = Date.new(@year, 1, 1)
      d_end = Date.new(@year, 12, 31)
			@shifts = @bus.bus_shifts.where(:date => [d_start..d_end]).order(:date).map{ |s|
				  s.date.strftime('%Y-%m-%d') + '|' + s.schedule_assignment.schedule_id.to_s
			}.join(',')
    end

    private
    def bus_params
      params.require(:bus).permit(:name, :bus_type, :seats, :seats_per_row, :passengeway, :reserved_seats, :company_id, :contact_name, :tel, :plate_number, :vin_number, :inspection_date)
    end
  end
end
