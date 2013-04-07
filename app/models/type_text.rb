class TypeText
  include Singleton

  def initialize
    @tts = InputType.all
  end

  def get_text(type_name, type_value)
    return '' unless type_value
    tt = @tts.detect{|s| s.type_name == type_name.to_s && s.type_value == type_value.to_s}
    if tt
      tt.type_text
    else
      type_value
    end
  end

  def get_texts(type_name, type_value)
    return '' unless type_value && type_value.length > 0
    tt = []
    type_value.each_char do |c|
      tt << get_text(type_name, c)
    end
    tt.join(',')
  end

end
