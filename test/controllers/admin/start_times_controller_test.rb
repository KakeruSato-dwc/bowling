require "test_helper"

class Admin::StartTimesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_start_times_new_url
    assert_response :success
  end
end
