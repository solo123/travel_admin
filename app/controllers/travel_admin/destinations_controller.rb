module TravelAdmin
  class DestinationsController < ResourceController
    def show
      load_object
    end
    private
      def destination_params
        params.require(:destination).permit()
      end
  end
end
