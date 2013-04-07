module TravelAdmin
  module BaseHelper
    def cfg
      AppConfig.instance
    end
    def type_text
      TypeText.instance
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

    def class_for_error(model, method)
      if error_message_on :product, :name
      end
    end

    def formatted_date(date)
      if date
        date.strftime('%Y-%m-%d')
      else
        ''
      end
    end
    def formatted_shot_datetime(datetime)
      if datetime
        datetime.localtime.strftime('%Y-%m-%d')
      else
        ''
      end
    end


    # This method demonstrates the use of the :child_index option to render a
    # form partial for, for instance, client side addition of new nested
    # records.
    #
    # This specific example creates a link which uses javascript to add a new
    # form partial to the DOM.
    #
    #   <%= form_for @project do |project_form| %>
    #     <div id="tasks">
    #       <%= project_form.fields_for :tasks do |task_form| %>
    #         <%= render :partial => 'task', :locals => { :f => task_form } %>
    #       <% end %>
    #     </div>
    #   <% end %>
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

    def remove_nested(fields)
      out = ''
      out << fields.hidden_field(:_destroy) unless fields.object.new_record?
      out << (link_to icon('delete'), "#", :class => 'remove')
      out.html_safe
    end

    def preference_field_tag(name, value, options)
      case options[:type]
      when :integer
        text_field_tag(name, value, preference_field_options(options))
      when :boolean
        hidden_field_tag(name, 0) +
          check_box_tag(name, 1, value, preference_field_options(options))
      when :string
        text_field_tag(name, value, preference_field_options(options))
      when :password
        password_field_tag(name, value, preference_field_options(options))
      when :text
        text_area_tag(name, value, preference_field_options(options))
      else
        text_field_tag(name, value, preference_field_options(options))
      end
    end

    def preference_field_for(form, field, options)
      case options[:type]
      when :integer
        form.text_field(field, preference_field_options(options))
      when :boolean
        form.check_box(field, preference_field_options(options))
      when :string
        form.text_field(field, preference_field_options(options))
      when :password
        form.password_field(field, preference_field_options(options))
      when :text
        form.text_area(field, preference_field_options(options))
      else
        form.text_field(field, preference_field_options(options))
      end
    end

    def preference_field_options(options)
      field_options = case options[:type]
                      when :integer
                        { :size => 10,
                          :class => 'input_integer' }
                      when :boolean
                        {}
                      when :string
                        { :size => 10,
                          :class => 'input_string' }
                      when :password
                        { :size => 10,
                          :class => 'password_string' }
                      when :text
                        { :rows => 15,
                          :cols => 85 }
                      else
                        { :size => 10,
                          :class => 'input_string' }
                      end

      field_options.merge!({
        :readonly => options[:readonly],
        :disabled => options[:disabled]
      })
    end

    def preference_fields(object, form)
      return unless object.respond_to?(:preferences)
      object.preferences.keys.map{ |key|

        form.label("preferred_#{key}", t(key) + ": ") +
          preference_field_for(form, "preferred_#{key}", :type => object.preference_type(key))

      }.join("<br />").html_safe
    end

    def additional_field_for(controller, field)
      field[:use] ||= 'text_field'
      options = field[:options] || {}

      object_name, method = controller.controller_name.singularize, attribute_name_for(field[:name])

      case field[:use]
      when 'check_box'
        check_box(object_name, method, options, field[:checked_value] || 1, field[:unchecked_value] || 0)
      when 'radio_button'
        html = ''
        field[:value].call(controller, field).each do |value|
          html << radio_button(object_name, method, value, options)
          html << " #{value.to_s} "
        end
        html
      when 'select'
        select(object_name, method, field[:value].call(controller, field), options, field[:html_options] || {})
      else
        value = field[:value] ? field[:value].call(controller, field) : get_additional_field_value(controller, field)
        __send__(field[:use], object_name, method, options.merge(:value => value))
      end # case
    end

    def date_tag(date)
      dt = date.strftime("%Y-%m-%d") 
      "<time class='local-date' datetime='#{dt}T00:00:00Z'>#{dt}</time>".html_safe
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

    private
    def attribute_name_for(field_name)
      field_name.gsub(' ', '_').downcase
    end
  end
end
