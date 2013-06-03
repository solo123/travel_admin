module TravelAdmin
	class AdminToolsController < AdminController
    def reset_schedules
      @result = []
      Tour.all_tours.each do |tour|
        cnt = 0
        days = tour.days - 1
        if days > 0
          tour.schedules.where("schedules.status=1 and (strftime('%s',return_date)-strftime('%s',departure_date))/60/60/24 <> #{days}").each do |schedule|
            schedule.return_date = schedule.departure_date + days
            schedule.save
            cnt += 1
          end          
        end
        if cnt > 0
          @result << "#{cnt} schedules changed for tour #{tour.id}"
        end
      end
    end
  end
end

