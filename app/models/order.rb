class Order < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :schedule_assignment
  has_one :order_detail
  has_one :order_price
  has_one :voucher
  has_many :order_items
  has_many :payments, :as => :payment_data
  has_many :bus_seats
  has_many :remarks, :as => :note_data, :dependent => :destroy
  has_many :account_histories, :as => :balance_object

  accepts_nested_attributes_for :order_detail, :allow_destroy => true
  accepts_nested_attributes_for :order_price, :allow_destroy => true
  accepts_nested_attributes_for :order_items, :allow_destroy => true, :reject_if => proc { |attributes| attributes['num_adult'].blank? || attributes[:num_adult].to_i < 1 }

  after_create :gen_order_number
  default_scope order('id desc')

  def gen_order_number
    self.order_number = "#{(created_at.year - 2000).to_s(36)[-1].chr}#{created_at.month.to_s(36)}#{created_at.day.to_s(36)}#{('%04d' % id).to_s[-4..-1]}".upcase
    self.save
  end

  def set_seats(seats)
    return unless self.schedule_assignment
    BusSeat.where(:order_id => self.id).delete_all
    return if seats.blank?

    order_seats = eval('[' + seats + ']') if seats.class.name == 'String'
    order_seats.each do |seat_number|
      seat_now = self.schedule_assignment.seats.where(:seat_number => seat_number).first || self.schedule_assignment.seats.build
      seat_now.seat_number = seat_number
      seat_now.order = self
      seat_now.save
    end
  end
  def ready_to_payment?
    !self.new_record? && order_detail && order_detail.user_info && order_price && order_price.total_amount > 0 && (!status || status < 3)
  end
  def change_status_after_payment
    if self.order_price.balance_amount == 0
      self.status = 3
    else
      self.status = 2
    end
  end
  def pay(payment)
    hist = self.account_histories.build
    hist.sub_balance(self.order_price.balance_amount, payment.amount)
    self.order_price.balance_amount = hist.balance_after
    hist.payment = payment
    change_status_after_payment
    self.save
  end
end
