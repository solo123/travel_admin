class Telephone < ActiveRecord::Base
  belongs_to :tel_number, :polymorphic => :true
  def to_s
    "[#{self.tel_type}] #{self.tel}"
  end
end
