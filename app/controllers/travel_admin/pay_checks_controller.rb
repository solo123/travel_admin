module TravelAdmin
  class PayChecksController < PayMethodsController
    def create
      @object = PayCheck.new(params[:pay_check])
      super
    end
  end
end


