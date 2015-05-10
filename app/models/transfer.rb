class Transfer < ActiveRecord::Base
	belongs_to :employee_info
	belongs_to :from_account, class_name: 'Account'
	belongs_to :to_account, class_name: 'Account'
	def to_s
		"Transfer ##{self.id}"
	end
end

