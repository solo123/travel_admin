class PayCompany < ActiveRecord::Base
  belongs_to :payment
  belongs_to :company
  belongs_to :account
  belongs_to :confirm_by, :class_name => 'Employee'
  belongs_to :finished_by, :class_name => 'Employee'

  scope :new_payments, where(:bill_id => nil)
end

