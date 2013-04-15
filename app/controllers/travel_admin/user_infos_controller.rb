module TravelAdmin
  class UserInfosController < ResourceController

    def find
      @no_log = 1
    end
	  def search
      @no_log = 1
	    r = []
      if params[:q] && params[:q].length > 2
      Telephone.where('tel like ?', "%#{params[:q]}%").where(:tel_number_type => 'UserInfo').limit(100).order(:tel).each do |tel|
        u = tel.tel_number
        r << UserResult.new(u.id, u.full_name, tel.tel, u.emails.first, u.addresses.first)
      end
	    UserInfo.where("full_name like ?", "%#{params[:q]}%").limit(100 - r.count).order('full_name').each do |u|
        r << UserResult.new(u.id, u.full_name, u.telephones.first, u.emails.first, u.addresses.first)
	    end if r.count < 100
      Email.where('email_address like ?', "%#{params[:q]}%").where(:email_data_type => 'UserInfo').limit(100 - r.count).each do |em|
        if em.email_data_type == 'UserInfo'
          u = em.email_data
          r << UserResult.new(u.id, u.full_name, u.telephones.first, em.email_address, u.addresses.first)
        end
      end if r.count < 100
      end
      @collection = r
	    render 'search_result', :layout => nil
	  end
    def brief
      @no_log = 1
      @object = UserInfo.find(params[:id]) if params[:id]
    end
    def select
      if params[:id].to_i > 0
        load_object
      else
        @object = UserInfo.new
      end
    end

  end
  
end
