require "test_helper"

class SandwichesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sandwiches_new_url
    assert_response :success
  end

  test "should get create" do
    get sandwiches_create_url
    assert_response :success
  end
end
