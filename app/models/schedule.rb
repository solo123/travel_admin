class Schedule < ActiveRecord::Base
  belongs_to :tour
  has_many :assignments, :class_name => 'ScheduleAssignment'
  accepts_nested_attributes_for :assignments, :reject_if => :all_blank
  
  has_many :orders

  has_one :price, :class_name => 'SchedulePrice'
  accepts_nested_attributes_for :price

  default_scope { order('departure_date, tour_id') }
  scope :ready_schedules, -> { where('departure_date>=?', Date.today) }
end
