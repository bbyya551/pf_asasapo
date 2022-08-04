require "test_helper"

class Public::AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get public_announcements_edit_url
    assert_response :success
  end
end
