module TravelAdmin
  class Tours::SpotsController < ResourceController
    def new
      load_parent
      @object = @tour.spots.build
    end
    def create
      load_parent
      @object = @tour.spots.build(params[:spot])
      @tour.save
    end

    def show
      # set tour icon
      load_object
      @object.tour.title_photo = @object.destination.title_photo
      @object.tour.save
    end
    def destroy
      @object = Spot.find(params[:id])
      @object.destroy
    end

    private
      def load_collection
        load_parent
        @collection = @tour.spots
      end 
      def load_object
        load_parent
        @object = Spot.find(params[:id])
      end
      def load_parent
        @parent = @tour = Tour.find(params[:tour_id])
      end
 
  end
end

