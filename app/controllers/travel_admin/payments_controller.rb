module TravelAdmin
  class PaymentsController < ResourceController
    def refund
    end
    protected
      def load_object
        @object = object_name.classify.constantize.find_by_id(params[:id])
        @order = Order.find(params[:order_id])
      end
  end
end
