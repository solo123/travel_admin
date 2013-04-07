class ScheduleAssignment < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :bus, :class_name => 'Bus'
  belongs_to :driver, :class_name => 'EmployeeInfo'
  belongs_to :driver_assistance, :class_name => 'EmployeeInfo'
  belongs_to :tour_guide, :class_name => 'EmployeeInfo'
  belongs_to :tour_guide_assistance, :class_name => 'EmployeeInfo'

  has_many :seats, :class_name => 'BusSeat'
  has_many :bus_shifts
  has_many :employee_shifts

  after_create :add_shifts
  after_update :add_shifts
  before_destroy :del_shifts

  validate :check_driver
  validate :check_tour_guide

  def check_driver
    errors.add(:driver_assistance_id, 'cannot same as driver') if driver_id && driver_id == driver_assistance_id
  end
  def check_tour_guide
    errors.add(:tour_guide_assistance_id, 'cannot same as tour guide') if tour_guide_id && tour_guide_id == tour_guide_assistance_id
  end

  def total_seats
    if self.bus
      self.bus.seats
    else
      57
    end
  end

  def valid_buses
    return nil unless self.schedule && self.schedule.departure_date && self.schedule.return_date
    range = self.schedule.departure_date..self.schedule.return_date
    bus_in_shift = BusShift.select('DISTINCT bus_id').where(:date => range).map(&:bus_id)
    bus_in_reserved = BusReservedDate.select('DISTINCT bus_id').where('bus_id is not null').where('from_date >= ? and to_date <= ?', self.schedule.return_date, self.schedule.departure_date).map(&:bus_id)
    buses = Bus.where(:status => 1)
    buses = buses.where('id not in (?)', bus_in_shift) if bus_in_shift.length > 0
    buses = buses.where('id not in (?)', bus_in_reserved) if bus_in_reserved.length > 0
    buses
  end
  def valid_buses_list
    bus_list = valid_buses.collect{|bus| [bus.name, bus.id]}
    bus_list.insert(0, [self.bus.name, self.bus.id]) if self.bus
    bus_list
  end
  def valid_employee(role)
    return nil unless self.schedule && self.schedule.departure_date && self.schedule.return_date
    range = self.schedule.departure_date..self.schedule.return_date
    emp_in_shift = EmployeeShift.select('DISTINCT employee_info_id').where(:date => range).map(&:employee_info_id)
    emps = EmployeeInfo.where(:status => 1).where('roles like ?', "%#{role}%")
    emps = emps.where('id not in (?)', emp_in_shift) if emp_in_shift.length > 0
    emps
  end
  def valid_employee_list(role)
    emps_list = valid_employee(role).collect{|e| [e.nickname, e.id]}
    emps_list.insert(0, [self.tour_guide_assistance.nickname, self.tour_guide_assistance_id]) if self.tour_guide_assistance
    emps_list.insert(0, [self.tour_guide.nickname, self.tour_guide_id]) if self.tour_guide
    emps_list.insert(0, [self.driver_assistance.nickname, self.driver_assistance_id]) if self.driver_assistance
    emps_list.insert(0, [self.driver.nickname, self.driver_id]) if self.driver
    emps_list
  end

  private
  def add_shifts
    return unless self.changed? && self.schedule
    s = self.schedule
    if self.bus_id_changed?
      self.bus_shifts.destroy_all
      s.departure_date.upto(s.return_date).each do |d|
        bs = self.bus_shifts.build(:bus_id => self.bus_id, :date => d)
        bs.save
      end
    end
    unless (self.changed & %w(driver_id driver_assistance_id tour_guide_id tour_guide_assistance_id) ).empty?
      self.employee_shifts.destroy_all
      rs = []
      rs << self.driver_id if self.driver_id
      rs << self.driver_assistance_id if self.driver_assistance_id
      rs << self.tour_guide_id if self.tour_guide_id
      rs << self.tour_guide_assistance_id if self.tour_guide_assistance_id
      unless rs.empty?
        s.departure_date.upto(s.return_date).each do |d|
          rs.each do |r|
            es = self.employee_shifts.build(:employee_info_id => r, :date => d )
            es.save
          end
        end
      end
    end
  end
  def del_shifts
    self.bus_shifts.destroy_all
    self.employee_shifts.destroy_all
  end

end
