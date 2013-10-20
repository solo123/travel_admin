module TravelAdmin
	class TelephonesController < ResourceController
    private
      def telephone_params
        params.require(:telephone).permit()
      end
	end
end
