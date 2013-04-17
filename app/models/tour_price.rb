class TourPrice < ActiveRecord::Base
  belongs_to :tour
  def set_new_default
    self.buy_two_get_one_free = 1
    self
  end
end
