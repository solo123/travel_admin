class EmployeeInfo < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  has_many :accounts, :as => :owner
  has_many :photos, :as => :photo_data, :dependent => :destroy
  belongs_to :title_photo, :class_name => 'Photo'
  has_many :employee_shifts

  def self.in_role(role)
    self.where(:status => 1).where('roles like ?', "%#{role}%")
  end
end
