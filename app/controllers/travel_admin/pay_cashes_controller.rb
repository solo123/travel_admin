module TravelAdmin
  class PayCashesController < PayMethodsController
    def create
      @object = PayCash.new(params[:pay_cash])
      super
    end
  end
end

