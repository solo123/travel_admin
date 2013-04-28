class Voucher < ActiveRecord::Base
	belongs_to :order
	belongs_to :payment
  belongs_to :employee_info
end
