module TravelAdmin
  module ApplicationHelper
    def cfg
      AppConfig.instance
    end
    def type_text
      TypeText.instance
    end

    def has_auth(action_name)
      roles = current_employee.employee_info.roles
      auth = Auth.find_by_action(action_name)
      if auth.nil? 
        auth = Auth.new(:role => '', :action => action_name)
        auth.save
      end
      return true if /X/.match(roles)
      return false if auth.role.empty?
      auth.role.match(Regexp.new("[#{roles}]"))
    end

    def website_link_to_view(resource, options={})
      options[:target] = 'website'
      options[:class] = 'btn btn-default'
      options[:title] = 'View on website'
      link_to(raw('<i class="icon-eye-open"></i>'), website_url(resource), options)
    end
    def link_to_new(resource_label, resource_url)
      link_to raw("<i class=\"icon-plus icon-white\"></i> #{resource_label}"), resource_url, :remote => true, :class => 'btn btn-success'
    end

    def row_link_to_edit(resource, options = {})
      options[:remote] = true
      options[:title] = 'Edit'
      options[:class] = 'btn btn-success'
      link_to(raw('<i class="icon-edit icon-white"></i>'), edit_object_url(resource), options)
    end
    def button_link_to_edit(resource, options = {})
      options[:remote] = true
      options[:title] = 'Edit'
      options[:class] = 'btn btn-success'
      link_to(raw('<i class="icon-pencil"></i> Edit'), edit_object_url(resource), options)
    end

    def row_link_to_photo(resource_path, options = {})
      options[:title] = 'Photos'
      options[:class] = 'btn btn-default'
      options[:target] = 'edit-win'
      link_to(raw('<i class="icon-picture"></i>'), resource_path, options)
    end

    def row_link_to_hide(resource, options = {})
      options[:title] = 'Show/Hide'
      options[:class] = 'btn btn-warning'
      options['data-method'] = 'delete'
      options[:remote] = true
      options['data-confirm'] = "Make this data Show/Hide from website.\n\nAre you sure?"
      link_to(raw('<i class="icon-trash"></i>'), object_url(resource), options)
    end

    def icon_link_to(label_text, to_url, options = {})
      icon = options[:icon]
      options.delete(:icon)
      if options[:class]
        options[:class] += ' btn btn-default' if (options[:class].exclude? 'btn')
      else
        options[:class] = 'btn btn-default'
      end
      lb = label_text
      lb = "<i class='#{icon}'></i> " + label_text if icon
      link_to( raw(lb), to_url, options)
    end
    def icon_link(label_text, to_url, options = {})
      icon = options[:icon]
      options.delete(:icon)
      lb = label_text
      lb = "<i class='#{icon}'></i> " + label_text if icon
      if options[:class] && options[:class].include?('disabled')
        options.delete(:onclick)
        options.delete(:remote)
        options.delete(:method)
        options.delete(:confirm)
        link_to(raw(lb), '#', options)
      else
        link_to( raw(lb), to_url, options)
      end
    end
    def search_button
      button_tag raw('<i class="icon-search"></i> Search'), :class => 'btn btn-default'
    end

    def edit_object_url(object, options = {})
      send "edit_#{object.class.name.underscore.split('/').last}_url", object, options
    end

    def generate_html(form_builder, method, options = {})
      options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
      options[:partial] ||= method.to_s.singularize
      options[:form_builder_local] ||= :f

      form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
        render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
      end

    end

    def generate_template(form_builder, method, options = {})
      escape_javascript generate_html(form_builder, method, options)
    end
    def add_object_js_link(name, form, method, partial, where)
      link_to_function name, %{
var new_object_id = new Date().getTime(); 
var html = $("#{generate_template(form, method, :partial => partial)}".replace(/NEW_RECORD/g, new_object_id)).hide();html.appendTo($("#{where}")).slideDown('slow')}
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

    def field_container(model, method, options = {}, &block)
      css_classes = options[:class].to_a
      if error_message_on(model, method).present?
        css_classes << 'withError'
      end
      content_tag('p', capture(&block), :class => css_classes.join(' '), :id => "#{model}_#{method}_field")
    end

    def error_message_on(object, method, options = {})
      object = convert_to_model(object)
      obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

      if obj && obj.errors[method].present?
        errors = obj.errors[method].map { |err| h(err) }.join('<br />').html_safe
        content_tag(:span, errors, :class => 'formError')
      else
        ''
      end
    end
    def formatted_date(date)
      if date
        date.strftime('%Y-%m-%d')
      else
        ''
      end
    end

    def date_tag(date)
      dt = ''
      dt = date.strftime("%Y-%m-%d") if date
      "<time class='local-date' datetime='#{dt}T00:00:00Z'>#{dt}</time>".html_safe
    end
    def date_text_field(form, field)
      dt = ''
      dt = form.object[field].strftime("%Y-%m-%d") if form.object[field]
      form.text_field field, :value => dt, :class => 'date-picker'
    end



    private
    def attribute_name_for(field_name)
      field_name.gsub(' ', '_').downcase
    end
  end
end
