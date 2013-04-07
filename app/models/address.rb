class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :address_data, :polymorphic => :true
  def to_s
    [self.address1, self.address2, self.zipcode, self.city.to_s].join(',')
  end
end
