module TravelAdmin
  class BusesController < ResourceController
    def shifts
      @shifts = BusShift.where(:bus_id => params[:id])

      @datelist = ''
      @shifts.each do |s|
        @datelist << "#{s.date.strftime('%Y.%m.%d')}|#{s.schedule_assignment.schedule_id},#{s.schedule_assignment_id};"
      end
    end
  end
end
