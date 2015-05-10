require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test "prepare order" do
		order = orders(:one)
    assert_instance_of Order, order, "prepare first_order"

    biz_payment = Biz::OrderPayment.new
  end
end

