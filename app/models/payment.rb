class Payment < ActiveRecord::Base
  belongs_to :payment_data, :polymorphic => true
  belongs_to :pay_from, :polymorphic => true
  belongs_to :pay_to, :polymorphic => true
  belongs_to :pay_method, :polymorphic => true
  belongs_to :operator, :class_name => 'EmployeeInfo'
  belongs_to :received_by, :class_name => 'EmployeeInfo'
  belongs_to :account
  has_many :account_histories

  def balance_data(account_type)
    account_histories.where(:balance_object_type => account_type).first
  end
end
