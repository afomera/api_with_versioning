require "test_helper"

class Api::SecretKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_secret_key = api_secret_keys(:one)
  end

  test "should get index" do
    get api_secret_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_api_secret_key_url
    assert_response :success
  end

  test "should create api_secret_key" do
    assert_difference("Api::SecretKey.count") do
      post api_secret_keys_url, params: { api_secret_key: { account_id: @api_secret_key.account_id, token: @api_secret_key.token } }
    end

    assert_redirected_to api_secret_key_url(Api::SecretKey.last)
  end

  test "should show api_secret_key" do
    get api_secret_key_url(@api_secret_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_api_secret_key_url(@api_secret_key)
    assert_response :success
  end

  test "should update api_secret_key" do
    patch api_secret_key_url(@api_secret_key), params: { api_secret_key: { account_id: @api_secret_key.account_id, token: @api_secret_key.token } }
    assert_redirected_to api_secret_key_url(@api_secret_key)
  end

  test "should destroy api_secret_key" do
    assert_difference("Api::SecretKey.count", -1) do
      delete api_secret_key_url(@api_secret_key)
    end

    assert_redirected_to api_secret_keys_url
  end
end
