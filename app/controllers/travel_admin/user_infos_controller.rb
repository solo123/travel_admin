module TravelAdmin
  class UserInfosController < ResourceController
    layout nil
    layout 'admin', :except => [:search, :brief]
	  def search
      @no_log = 1
	    r = []
      Telephone.where('tel like ?', "%#{params[:term]}%").limit(100).order(:tel).each do |tel|
        if tel.tel_number_type == 'UserInfo'
          u = tel.tel_number
          r << {:value => "#{u.id}: #{u.full_name}, tel:#{tel.tel}", :id => u.id}
        end
      end
	    UserInfo.where("full_name like ?", "%#{params[:term]}%").limit(100 - r.count).order('full_name').each do |t|
	      r << {:value => "#{t.id}: #{t.full_name}", :id => t.id}
	    end if r.count < 100
      Email.where('email_address like ?', "%#{params[:term]}%").limit(100 - r.count).each do |em|
        if em.email_data_type == 'UserInfo'
          u = em.email_data
          r << {:value => "#{u.id}: #{u.full_name}, email:#{em.email_address}", :id => u.id}
        end
      end if r.count < 100
	    render :text => r.to_json
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
