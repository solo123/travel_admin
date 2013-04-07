class Email < ActiveRecord::Base
  belongs_to :email_data, :polymorphic => :true
  def to_s
    self.email_address
  end
end
