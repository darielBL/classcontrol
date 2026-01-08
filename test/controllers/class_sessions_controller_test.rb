require "test_helper"

class ClassSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get class_sessions_index_url
    assert_response :success
  end

  test "should get create" do
    get class_sessions_create_url
    assert_response :success
  end

  test "should get update" do
    get class_sessions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get class_sessions_destroy_url
    assert_response :success
  end
end
