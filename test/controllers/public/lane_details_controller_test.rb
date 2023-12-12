require "test_helper"

class Public::LaneDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_lane_details_create_url
    assert_response :success
  end

  test "should get update" do
    get public_lane_details_update_url
    assert_response :success
  end
end
