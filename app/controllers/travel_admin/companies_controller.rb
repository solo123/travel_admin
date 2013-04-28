module TravelAdmin
  class CompaniesController < ResourceController
    def new_invoice
      load_object
    end
    def search_agent
      @no_log = 1
      max_count = 100
      fields = "companies.id, companies.short_name, companies.company_name, contacts.contact_name, telephones.tel"
      r = []
      if params[:q] && params[:q].length > 1
        ptn = "%#{params[:q]}%"
        r += Company.select(fields).where('(companies.short_name like :ptn) or (companies.company_name like :ptn)', {:ptn => ptn}).order(:company_name).joins('left outer join contacts on company_id=companies.id').joins('left outer join telephones on tel_number_type="Contact" and tel_number_id=contacts.id').limit(max_count).map{|t| [t.id, t.short_name, t.company_name, t.contact_name, t.tel]}
        r += Contact.select(fields).where("contact_name like ?", ptn).order('contact_name').joins('left outer join companies on contacts.company_id=companies.id').joins('left outer join telephones on tel_number_type="Contact" and tel_number_id=contacts.company_id').limit(max_count - r.count).map{|t| [t.id, t.short_name, t.company_name, t.contact_name, t.tel]} if r.count < max_count
        r += Telephone.select(fields).where('tel like ?', ptn).where(:tel_number_type => 'Contact').order(:tel).joins('left outer join contacts on tel_number_id=contacts.id').joins('left outer join companies on contacts.company_id=companies.id').limit(max_count - r.count).map{|t| [t.id, t.short_name, t.company_name, t.contact_name, t.tel]} if r.count < max_count
      end
      @collection = r
      render 'search_result', :layout => nil
    end
  end
end
