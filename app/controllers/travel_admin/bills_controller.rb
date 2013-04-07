module TravelAdmin
	class BillsController < ResourceController
    def create
      bill = Bill.new(params[:bill])
      if params["cb"]
        ids = params["cb"].collect { |item| item[0] }.join(',')
        unless ids.empty?
          bill.save
          PayCompany.where("id in (#{ids})").update_all(:bill_id => bill.id)
        end
      end
    end
  end
end

