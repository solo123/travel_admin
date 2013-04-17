class Tour < ActiveRecord::Base
  has_one :description, :as => :desc_data, :dependent => :destroy
  accepts_nested_attributes_for :description, :allow_destroy => true
  has_many :spots, :order => 'visit_day, visit_order'
  belongs_to :title_photo, :class_name => 'Photo'
  
  has_one :tour_setting, :dependent => :destroy
  accepts_nested_attributes_for :tour_setting, :allow_destroy => true
  has_one :tour_price, :dependent => :destroy
  accepts_nested_attributes_for :tour_price, :allow_destroy => true
  
  has_many :schedules
  has_many :active_schedules, :class_name => 'Schedule', :conditions => ['departure_date > ?', Date.today + 1]
  
  scope :all_tours, where(:status => 1)
  scope :bus_tours, where(:status => 1).where(:tour_type => 1)
  scope :packages, where(:status => 1).where(:tour_type => 2)
  scope :cruises, where(:status => 1).where(:tour_type => 3)

  scope :visible, where(:status => 1).order('title')
  scope :no_icon, where(:status => 1).where(:title_photo_id => nil).order('title')
  def tour_type_name
    if self.tour_type && self.tour_type >=0 && self.tour_type < 4
      ['', 'Bus Tour', 'Package', 'Cruise'][self.tour_type] 
    else
      self.tour_type
    end
  end
  def tour_type_menu_id
    if self.tour_type && self.tour_type >= 0 && self.tour_type < 4
      ['', 'bus', 'package', 'cruise'][self.tour_type] if self.tour_type
    else
      self.tour_type
    end
  end
  def status_text
    if self.status && self.status >= 0 && self.status < 2
      %w(hide show)[self.status] if self.status
    else
      self.status
    end
  end

  def ready_to_gen?
    tour_setting && tour_setting.is_auto_gen == 1 && (!tour_setting.last_schedule_date || Date.parse(tour_setting.last_schedule_date) < Date.today) && tour_price && tour_price.price1 && tour_price.price2 && tour_price.price3 && tour_price.price4 && tour_price.price1 > 0 && tour_price.price2 >= tour_price.price1 && tour_price.price3 >= tour_price.price2 && tour_price.price4 >= tour_price.price3
  end

  def add_schedule(day)
    return nil if !day || self.schedules.exists?(:departure_date => day)
    
    s = self.schedules.build
    s.departure_date = day
    s.return_date = day + days
    s.status = 1
    p = s.build_price
    if self.tour_price
      tp = self.tour_price
      p.price_adult = tp.price_adult
      p.price_child = tp.price_child
      p.price1 = tp.price1
      p.price2 = tp.price2
      p.price3 = tp.price3
      p.price4 = tp.price4
    end
    ass = s.assignments.build
    ass.save
    s.save    
    s
  end
  def gen_schedule(day)
    add_schedule(day) if self.tour_setting.weekly.include? day.days_to_week_start(:sunday).to_s
  end
    
end
