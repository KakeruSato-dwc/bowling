require "test_helper"

class Admin::StartDatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_start_dates_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_start_dates_new_url
    assert_response :success
  end

  test "should get show" do
    get admin_start_dates_show_url
    assert_response :success
  end
end
