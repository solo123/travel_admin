module TravelAdmin
  class PayCompaniesController < PayMethodsController
    def create
      @object = PayCompany.new(params[:pay_company])
      super
    end
  end
end



