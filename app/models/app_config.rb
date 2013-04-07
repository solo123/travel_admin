class AppConfig
  include Singleton

  def initialize
    reload
  end

  def reload
    @configs = AppConfiguration.all
  end
  def get_config(key)
    cf = @configs.detect{ |c| c.key == key.to_s }
    cf.val if cf
  end


end

