class EmployeeInfo < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  has_many :accounts, :as => :owner
  has_many :photos, :as => :photo_data, :dependent => :destroy
  belongs_to :title_photo, :class_name => 'Photo'
  has_many :employee_shifts
	has_many :messages, foreign_key: :creator_id
	has_many :message_receipts
	has_many :msg_receipts, through: :message_receipts, source: :message

  def self.in_role(role)
    self.where(:status => 1).where('roles like ?', "%#{role}%")
  end
	def to_s
		self.nickname
	end
	def name_with_company
		"#{self.nickname}@#{self.company.short_name if self.company}"
	end
end
