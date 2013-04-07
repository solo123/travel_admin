class BusReservedDate < ActiveRecord::Base
  belongs_to :bus
  belongs_to :employee_info
end

