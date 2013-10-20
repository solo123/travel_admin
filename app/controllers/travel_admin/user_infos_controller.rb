module TravelAdmin
  class UserInfosController < ResourceController
    before_filter :set_no_log
    def set_no_log
      @no_log = 1
    end
    autocomplete :user_info, :search, :column_name => 'full_name', display_value: 'full_info'
    def get_autocomplete_items(params)
      items = UserInfo.all
    end
    def find
      @no_log = 1
    end
	  def search
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
      @object = UserInfo.find(params[:id]) if params[:id]
    end
    def select
      if params[:id].to_i > 0
        load_object
      else
        @object = UserInfo.new
      end
    end
    def create
		  params.permit!
      @object = UserInfo.new(params[:user_info])
      @object.payment_name = @object.full_name
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
    def update
      load_object
		  params.permit!
      @object.attributes = params[object_name.singularize.parameterize('_')]
      @object.payment_name = @object.full_name if @object.full_name_changed?
      if @object.changed_for_autosave?
        @changes = @object.all_changes
        if @object.save
        else
          flash[:error] = @object.errors.full_messages.to_sentence
          @no_log = 1
        end
      end
    end
    private
      def user_info_params
        params.require(:user_info).permit(:full_name, :status, :telephones, :emails, :addresses)
      end

  end
  
end
