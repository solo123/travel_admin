class PayVoucher < ActiveRecord::Base
  belongs_to :payment
  belongs_to :received_by, :class_name => 'EmployeeInfo'
  belongs_to :account
  belongs_to :voucher
end

