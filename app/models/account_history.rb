class AccountHistory < ActiveRecord::Base
  belongs_to :balance_data, :polymorphic => :true
  belongs_to :payment

  def sub_balance(last_balance, current_amount)
    self.balance_before = last_balance
    self.amount = - current_amount
    self.balance_after = last_balance - current_amount
  end
  def add_balance(last_balance, current_amount)
    self.balance_before = last_balance
    self.amount = current_amount
    self.balance_after = last_balance + current_amount
  end
end


