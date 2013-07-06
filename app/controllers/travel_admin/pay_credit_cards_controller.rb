module TravelAdmin
  class PayCreditCardsController < PayMethodsController
    def index
      params[:search] ||= {}
      @search = PayCreditCard.metasearch(params[:search]).where(:status => 0)
      pages = cfg.get_config(:admin_list_per_page).to_i
      pages = 20 unless pages > 1
      @collection = @search.paginate(:page => params[:page], :per_page => pages)
    end
    def create
      @object = PayCreditCard.new(params[:pay_credit_card])
      super
    end
    def destroy
      @object = PayCreditCard.find(params[:id])
      biz = Biz::OrderPayment.new
      biz.withdraw(@object, current_employee.employee_info)
      unless biz.errors.blank?
        flash[:error] = biz.errors.to_sentence
        @log_text = "withdraw credit card error: " + biz.errors.to_sentence
      end
    end
    def update
      super
      if params[:lookcard] && @object.status == 0
        order = @object.order
        if order
          biz_payment = Biz::OrderPayment.new
          biz_payment.pay(order, @object, current_employee.employee_info) 
          if biz_payment.errors.blank? 
             
          else
            flash[:error] = biz_payment.errors.to_sentence
            @no_log = 1
          end
        end
      end
      redirect_to :action => :index
    end
    def look_card
    end
    protected
      def load_collection
        params[:search] ||= {}
        @search = PayCreditCard.metasearch(params[:search]).where(:status => 0)
        pages = cfg.get_config(:admin_list_per_page).to_i
        pages = 20 unless pages > 1
        @collection = @search.paginate(:page => params[:page], :per_page => pages)
      end 
  end
end


