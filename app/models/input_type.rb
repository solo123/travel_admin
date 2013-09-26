class InputType < ActiveRecord::Base
  scope :get_list, lambda { |type_name| where(:type_name => type_name).where(:status => 1) unless type_name.strip.empty? }
end
