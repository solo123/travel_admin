class Remark < ActiveRecord::Base
	belongs_to :note_data, :polymorphic => true
  belongs_to :employee_info
end
