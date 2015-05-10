module TravelAdmin
  class UserInfosController < ResourceController
    before_filter :set_no_log
    def set_no_log
      @no_log = 1
    end
    autocomplete :user_info, :search, :column_name => 'full_name', display_value: 'full_info', id_element: 'full_name'

    def get_autocomplete_items(params)
			ptn = "%#{params[:term]}%"
      items = UserInfo.where("(full_name like :ptn) or (telephone like :ptn) or (email like :ptn)", {ptn: ptn}).order('full_name').limit(100)
    end

    def find
      @no_log = 1
    end
	  def search
      fields = 'id, full_name, telephone, email'
      max_count = 100
      @collection = []
      if params[:q] && params[:q].length > 1
        ptn = "%#{params[:q]}%"
				@collection = UserInfo.select(fields).where("(full_name like :ptn) or (telephone like :ptn) or (email like :ptn)", {ptn: ptn}).order('full_name').limit(max_count)
      end
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
        params.require(:user_info).permit(:full_name, :status, :telephone, :email, :address)
      end

  end
  
end
