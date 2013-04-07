class City < ActiveRecord::Base
  def to_s
    t = []
    t << self.city if self.city && self.city.length > 0
    t << self.state if self.state && self.state.length > 0
    t << self.country if self.country && self.country.length > 0
    t.join(', ')
  end
end
