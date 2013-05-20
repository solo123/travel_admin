class PayCreditCard < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :user_info
  belongs_to :order
  has_one :telephone, :as => :tel_number, :dependent => :destroy
  has_one :address, :as => :address_data, :dependent => :destroy
  default_scope order('pay_credit_cards.id desc')
end

