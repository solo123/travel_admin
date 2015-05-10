class PayCash < ActiveRecord::Base
  belongs_to :payment
  belongs_to :received_by, :class_name => 'EmployeeInfo'
  belongs_to :account

  validate :amount_validate

  def amount_validate
    unless amount && amount != 0
      errors.add(:amount, "Please input amount")
    end
  end

end
