module TravelAdmin
  class Post < ActiveRecord::Base
    attr_accessible :text, :title
  end
end
