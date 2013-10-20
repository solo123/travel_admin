module TravelAdmin
	class AddressesController < ResourceController
    private
      def address_params
        params.require(:address).permit()
      end
	end
end
