module TravelAdmin
	class EmailsController < ResourceController
    private
      def email_params
        params.require(:email).permit()
      end
	end
end
