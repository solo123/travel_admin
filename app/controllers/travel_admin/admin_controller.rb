module TravelAdmin
	class AdminController < ActionController::Base
    before_filter :authenticate_employee!
    after_filter :log_operation
		helper 'search'
		layout 'travel_admin/application'

    attr_writer :title 
    def title
  	  @title ||=  controller_name + ' ' + action_name
    end
  def cfg
    AppConfig.instance
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

    def log_operation
      return if defined? @no_log
      log = Log.new
      log.employee_info = current_employee.employee_info
      log.current_sign_in_at = current_employee.current_sign_in_at
      log.last_sign_in_at = current_employee.last_sign_in_at
      log.sign_in_count = current_employee.sign_in_count
      log.page_url = request.headers['PATH_INFO']
      log.host = request.headers['SERVER_NAME']
      log.remote_addr = request.headers['REMOTE_ADDR']
      log.remote_host = request.headers['REMOTE_HOST']
      log.controller = controller_name
      log.action = action_name
      log.log_brief = @log_brief if defined? @log_brief
      log.log_text = @log_text if defined? @log_text
      log.level = 0
      if action_name == 'index'
        log.log_brief ||= 'list ' + log.controller
        log.level = 1
      elsif action_name == 'show'
        log.log_brief ||= 'view ' + log.controller + ':' + params[:id]
        log.level = 1
      elsif action_name == 'new' || action_name == 'edit'
        log.level = 0
      elsif action_name == 'create'
        log.log_brief ||= 'add new ' + log.controller
        log.ref_data = @object if defined? @object
        log.level = 3
      elsif action_name == 'update'
        log.log_brief ||= 'edit ' + log.controller + ': ' + params[:id]
        if !log.log_text && (defined? @object) && (defined? @changes) && @changes && @changes.length > 0
          log.log_text = @changes.length.to_s + ' changes maked: ' + @changes.to_s
          log.ref_data = @object
          log.level = 3
        else
          log.level = 0
        end
      elsif action_name == 'destroy'
        log.log_brief ||= 'hide/del ' + log.controller + ': ' + params[:id]
        log.log_text ||= params.to_s
        log.ref_data = @object if defined? @object
        log.level = 4
      else
        log.log_brief ||= "#{log.action} #{log.controller}: #{params[:id]}"
        log.log_text ||= params.to_s       
        if defined? @log_level
          log.level = @log_level 
        else
          log.level = 2
        end
      end
      log.save if log.level > 0
    end
	end
end
