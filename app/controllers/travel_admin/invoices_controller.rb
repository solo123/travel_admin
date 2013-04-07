module TravelAdmin
	class InvoicesController < ResourceController
    def create
      @object = Invoice.new(params[:invoice])
      if params[:cb]
        ids = params[:cb].collect { |item| item[0] }.join(',')
        unless ids.empty?
          @object.save
          PayCompany.where("id in (#{ids})").update_all(:invoice_id => @object.id)
        end
      end
    end
  end
end

