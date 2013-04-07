class TodoWorker < ActiveRecord::Base
  belongs_to :employee_info
  belongs_to :todo
end
