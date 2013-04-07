class PayCash < ActiveRecord::Base
  belongs_to :payment
  belongs_to :received_by, :class_name => 'EmployeeInfo'
  belongs_to :account

  validate :need_receiver, :amount_validate

  def amount_validate
    unless amount && amount != 0
      errors.add(:amount, "Please input amount")
    end
  end

  def need_receiver
    unless received_by_id && received_by_id > 0
      errors.add(:received_by_id, "Cannot pay without receive by")
    end
  end
end
