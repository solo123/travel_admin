class EmployeeShift < ActiveRecord::Base
  belongs_to :employee_info
  belongs_to :schedule_assignment
end
