module TravelAdmin
  class CitiesController < ResourceController
    def select
      if params[:id].to_i > 0
        @object = City.find(params[:id])
      else
        @object = City.new
      end
    end
	  def search
      @no_log = 1
	    r = []
	    r = City.where('city like :cnd or state like :cnd or country like :cnd',{:cnd => "%#{params[:term]}%"}).limit(100).order('city, state, country').collect{|city| {:value => [city.city, city.state, city.country].join(','), :id => city.id}}
	    render :text => r.to_json
	  end
    def get_detail
      render :text => City.find(params[:id]).title
    end
  end
end

