class MessageReceipt < ActiveRecord::Base
	belongs_to :message
  belongs_to :employee_info
	default_scope { order(id: :desc) }
	def message_title
		self.message.message_title
	end
	def send_to
		self.message.creator
	end
end


