require 'test_helper'

module TravelAdmin
  class PagesControllerTest < ActionController::TestCase
    test "should get temp" do
      get :temp
      assert_response :success
    end

  end
end
