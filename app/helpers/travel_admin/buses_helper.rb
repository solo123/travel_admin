module TravelAdmin
  module BusesHelper
    def gen_cal_table
      @year = Date.today.year
      @year = params[:year].to_i if params[:year]
      d_start = Date.new(@year, 1, 1)
      d_end = Date.new(@year, 12, 31)
      shifts = @bus.bus_shifts.where(:date => [d_start..d_end]).order(:date)
      @lnk_prev = shift_bus_path(@bus) + "?year=#{@year - 1}"
      @lnk_next = shift_bus_path(@bus) + "?year=#{@year + 1}"

      r = []
      sc = 0
      month = 0
      dd = 0
      (d_start..d_end).each do |d| 
        if month != d.month 
          if month > 0
            if dd > 0
              r << "<td></td>" * (7 - dd)
            end        
            r << "</table></div>\n"
          end
          month = d.month
          dd = d.days_to_week_start(:sunday)
          r << "\n\n<div class='month'><h4>"
          r << d.strftime("%B")
          r << "</h4><table>"
          r << "<thead><tr><th>Su</th><th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th></tr></thead>"
          r << "<tr>"
          if dd > 0
            r << '<td></td>' * dd
          end
        end

        if dd == 0 && d.day > 1
          r << "\n<tr>"
        end

        if sc < 1000
          sc = 1000 if sc >= shifts.length
          while sc < 1000 && d > shifts[sc].date do
            sc += 1
            sc = 1000 if sc >= shifts.length
          end      
        end

        if (sc < 1000) && (d == shifts[sc].date)
          unless shifts[sc].schedule_assignment
            shifts[sc].destroy
            r << '<td>' << d.day.to_s.rjust(2, '0') << '</td>'
          else
            r << '<td class="shift" title="Schedule #' << shifts[sc].schedule_assignment.schedule.id.to_s << '"><a href="'  << schedule_schedule_assignment_path(shifts[sc].schedule_assignment.schedule, shifts[sc].schedule_assignment) << '">' << d.day.to_s.rjust(2, '0') << '</a></td>'
          end
        else
          r << '<td>' << d.day.to_s.rjust(2, '0') << '</td>'
        end

        if dd == 6
          r << "</tr>"
        end
        dd = (dd + 1) % 7
      end
      if dd > 0
        r << "<td></td>" * (7 - dd)
      end
      r << "</table></div>\n"
      @r = r
    end
  end
end


