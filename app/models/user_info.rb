class UserInfo < ActiveRecord::Base
	belongs_to :user
	has_many :addresses, :as => :address_data, :order => 'updated_at desc', :dependent => :destroy
  has_many :emails, :as => :email_data, :order => 'updated_at desc', :dependent => :destroy
  has_many :telephones, :as => :tel_number, :order => 'updated_at desc', :dependent => :destroy
  has_many :photos, :as => :photo_data, :dependent => :destroy
  belongs_to :title_photo, :class_name => 'Photo'
  has_many :orders, :through => :order_details
  has_many :order_details

  accepts_nested_attributes_for :telephones, :allow_destroy => true, :reject_if => proc { |att| att['tel'].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true, :reject_if => proc { |att| att['email_address'].blank? }
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => proc {|att| att['address1'].blank? }
  def to_s
  	"#{self.full_name}"
  end

end
