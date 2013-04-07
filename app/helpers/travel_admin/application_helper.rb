module TravelAdmin
  module ApplicationHelper
      def link_to_show(resource, options={})
        link_to('Show', object_url(resource), options)
      end

      def website_link_to_view(resource, options={})
        options[:target] = 'website'
        link_to('View', website_url(resource), options)
      end
      def link_to_new(resource)
        link_to('Add', t("new"), edit_object_url(resource))
      end

      def link_to_edit(resource, options = {})
        options[:remote] = true
        link_to('Edit', edit_object_url(resource), options)
      end

      def link_to_hide(resource, options={})
        options[:remote] = true
        options['data-method'] = 'delete'
        options['data-confirm'] ||= 'Are you sure?'
        link_to('Hide', object_url(resource), options)
      end

      def edit_object_url(object, options = {})
        send "edit_#{object.class.name.underscore.split('/').last}_url", object, options
      end
      def website_url(object, options ={})
        "/#{object.class.name.underscore.split('/').last.pluralize}/#{object.id}"
      end
      def object_url(object, options = {})
        if object.class.name == 'Spot'
          send "tour_spot_path", object, options
        else
          send "#{object.class.name.underscore.split('/').last}_path", object, options
        end
      end
      def objects_url(object)
        if object.class.name == 'Spot'
          send "tour_spots_path"
        else
          send "#{object.class.name.underscore.split('/').last.pluralize}_path"
        end
      end
      def objects_path(object)
        "travel_admin/#{object.class.name.underscore.pluralize}"
      end
  end
end
