class Page < ActiveRecord::Base
  has_one :description, :as => :desc_data, :dependent => :destroy
  accepts_nested_attributes_for :description, :allow_destroy => true
  has_many :photos, :as => :photo_data, :dependent => :destroy
  
	def deleted?
    status && status == 1
  end
end
