class Message < ActiveRecord::Base
  belongs_to :creator, class_name: 'EmployeeInfo'
  belongs_to :reply_to, class_name: 'Message'
	has_many :message_receipts
	has_many :message_refs

	scope :draft, -> {where(status: 0)}
	scope :sent, -> {where('status>0')}
	default_scope {order(id: :desc)}

	def send_message
		return if self.status > 0
		self.send_to.split(',').each do |user|
			u_name, u_company = user.split('@')
			company = Company.find_by_short_name(u_company)
			u = EmployeeInfo.find_by_nickname_and_company_id(u_name, company)
		  self.add_receipt(u) if u
		end
		self.status = 1
		self.save
	end

	def add_receipt(user)
		self.message_receipts.new(employee_info: user)
	end

end

