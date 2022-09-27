require "test_helper"

class Public::ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_reports_new_url
    assert_response :success
  end

  test "should get create" do
    get public_reports_create_url
    assert_response :success
  end
end
