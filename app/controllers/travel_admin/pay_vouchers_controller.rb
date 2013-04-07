module TravelAdmin
  class PayVouchersController < PayMethodsController
    def create
      @object = PayVoucher.new(params[:pay_voucher])
      super
    end
  end
end



