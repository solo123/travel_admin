class BusShift < ActiveRecord::Base
  belongs_to :schedule_assignment
  belongs_to :bus
end
