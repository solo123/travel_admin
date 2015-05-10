class UserInfo < ActiveRecord::Base
	belongs_to :user
  has_many :photos, :as => :photo_data, :dependent => :destroy
  belongs_to :title_photo, :class_name => 'Photo'
  has_many :orders, :through => :order_details
  has_many :order_details

  def to_s
  	"#{self.full_name}"
  end

  def full_info
    "#{self.full_name} | #{self.telephone} | #{self.email}"
  end

end
