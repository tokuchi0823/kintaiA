require 'test_helper'

class BasicPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get basic" do
    get basic_pages_basic_url
    assert_response :success
  end

end
