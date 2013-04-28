module TravelAdmin
  class AgentResult
    attr_accessor :company_id, :short_name, :company_name, :contact_name, :phone
    def initialize(cid, s_name, c_name, contact_name, phone)
      @company_id = cid
      @short_name = s_name
      @company_name = c_name
      @contact_name = contact_name
      @phone = phone
    end
  end
end


