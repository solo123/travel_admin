module TravelAdmin
  class ResourceController < AdminController
    respond_to :html, :js, :json

    def index
      return @collection if @collection.present?
      load_collection
    end
    def show
       load_object
    end
    def edit
      load_object
    end
    def new
      @object = object_name.classify.constantize.new
    end
    def update
      load_object
		  params.permit!
      @object.attributes = params[object_name.singularize.parameterize('_')]
      if @object.changed_for_autosave?
        @changes = @object.all_changes
        if @object.save
        else
          flash[:error] = @object.errors.full_messages.to_sentence
          @no_log = 1
        end
      end
    end
    def create
		  params.permit!
      @object = object_name.classify.constantize.new(params[object_name.singularize.parameterize('_')])
      if @object.save
      else
        flash[:error] = @object.errors.full_messages.to_sentence
        @no_log = 1
      end
    end
    def destroy
      load_object
      if @object.status && @object.status > 0
        @object.status = 0
      else
        @object.status = 1
      end
      @object.save
    end
    
    protected
      def load_collection
        params[:q] ||= {}
        @q = object_name.classify.constantize.search(params[:q])
        pages = cfg.get_config(:admin_list_per_page).to_i
        pages = 20 unless pages > 1
        @collection = @q.result(distinct: true).paginate(:page => params[:page], :per_page => pages)
      end 
      def load_object
        @object = object_name.classify.constantize.find_by_id(params[:id])
      end
      def object_name
        controller_name #.singularize
      end

      def flash_message_for(object, event_sym)
        resource_desc  = object.class.model_name.human
        resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
        I18n.t(event_sym, :resource => resource_desc)
      end

      # Index request for JSON needs to pass a CSRF token in order to prevent JSON Hijacking
      def check_json_authenticity
        return unless request.format.js? or request.format.json?
        return unless protect_against_forgery?
        auth_token = params[request_forgery_protection_token]
        unless (auth_token and form_authenticity_token == URI.unescape(auth_token))
          raise(ActionController::InvalidAuthenticityToken)
        end
      end

    # URL helpers

      def new_object_url(options = {})
        if parent_data.present?
          new_polymorphic_url([:admin, parent, model_class], options)
        else
          new_polymorphic_url([:admin, model_class], options)
        end
      end

      def edit_object_url(object, options = {})
        if parent_data.present?
          send "edit_#{model_name}_#{object_name}_url", parent, object, options
        else
          send "edit_#{object_name}_url", object, options
        end
      end

      def object_url(object = nil, options = {})
        target = object ? object : @object
        if parent_data.present?
          send "#{model_name}_#{object_name}_url", parent, target, options
        else
          send "#{object_name}_url", target, options
        end
      end

      def collection_url(options = {})
        if parent_data.present?
          polymorphic_url([parent, model_class])
        else
          polymorphic_url(model_class)
        end
      end


  end
end
