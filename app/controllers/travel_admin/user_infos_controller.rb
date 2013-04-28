module TravelAdmin
  class UserInfosController < ResourceController

    def find
      @no_log = 1
    end
	  def search
      @no_log = 1
      fields = 'user_infos.id, user_infos.full_name, telephones.tel, emails.email_address'
      max_count = 100
	    r = []
      @collection = []
      if params[:q] && params[:q].length > 1
        ptn = "%#{params[:q]}%"
        r += Telephone.select(fields).where('tel_number_type="UserInfo" and tel like ?', ptn).order(:tel).joins('left outer join user_infos on tel_number_id=user_infos.id').joins('left outer join emails on tel_number_id=emails.email_data_id').limit(max_count).map{|t| [t.id, t.full_name, t.tel, t.email_address]}
        r += UserInfo.select(fields).where("full_name like ?", ptn).order('full_name').joins('left outer join telephones on tel_number_type="UserInfo" and tel_number_id=user_infos.id').joins('left outer join emails on email_data_type="UserInfo" and email_data_id=user_infos.id').limit(max_count - r.count).map{|t| [t.id, t.full_name, t.tel, t.email_address]} if r.count < max_count
        r += Email.select(fields).where('email_address like ?', ptn).where(:email_data_type => 'UserInfo').order(:email_address).joins('left outer join user_infos on email_data_id=user_infos.id').joins('left outer join telephones on telephones.tel_number_type="UserInfo" and telephones.tel_number_id=emails.email_data_id').limit(max_count - r.count).map{|t| [t.id, t.full_name, t.tel, t.email_address]} if r.count < max_count
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
