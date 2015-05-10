module TravelAdmin
  class OrderDetailsController < ResourceController
    def create
		  params.permit!
      @object = OrderDetail.new(params[:order_detail])
      if @object.save
				if @object.user_info
					ui = @object.user_info
					@object.full_name = ui.full_name
					@object.telephone = ui.telephone
					@object.email = ui.email
					@object.bill_address = ui.address
					@object.save
				end
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
  end
end
