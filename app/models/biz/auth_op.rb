module Biz
  class AuthOp
    def check_auth(action, roles)
      result = false
      if Auth.exists?(:action => action)
        auth = Auth.where(:action => action).first
        if auth.role && auth.role.length > 0
          r = Regexp.new("[#{auth.role}]")
          result = true if roles.index(r)
        end
      else
        auth = Auth.new(:action => action)
        auth.save
      end
      result
    end
  end
end

