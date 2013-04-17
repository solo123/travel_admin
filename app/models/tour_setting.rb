class TourSetting < ActiveRecord::Base
  belongs_to :tour
  def set_new_default
    self.is_auto_gen = 1
    self.has_seat_table = 1
    self
  end
end
