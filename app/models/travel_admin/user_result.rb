module TravelAdmin
  class UserResult
    attr_accessor :user_info_id, :name, :phone, :email, :address
    def initialize(uid, name, phone, email, address)
      @user_info_id = uid
      @name = name
      @phone = phone
      @email = email
      @address = address
    end
  end
end

