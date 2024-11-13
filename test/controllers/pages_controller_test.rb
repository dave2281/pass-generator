require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get password" do
    get pages_password_url
    assert_response :success
  end
end
