require "application_system_test_case"

class Api::SecretKeysTest < ApplicationSystemTestCase
  setup do
    @api_secret_key = api_secret_keys(:one)
  end

  test "visiting the index" do
    visit api_secret_keys_url
    assert_selector "h1", text: "Secret keys"
  end

  test "should create secret key" do
    visit api_secret_keys_url
    click_on "New secret key"

    fill_in "Account", with: @api_secret_key.account_id
    fill_in "Token", with: @api_secret_key.token
    click_on "Create Secret key"

    assert_text "Secret key was successfully created"
    click_on "Back"
  end

  test "should update Secret key" do
    visit api_secret_key_url(@api_secret_key)
    click_on "Edit this secret key", match: :first

    fill_in "Account", with: @api_secret_key.account_id
    fill_in "Token", with: @api_secret_key.token
    click_on "Update Secret key"

    assert_text "Secret key was successfully updated"
    click_on "Back"
  end

  test "should destroy Secret key" do
    visit api_secret_key_url(@api_secret_key)
    click_on "Destroy this secret key", match: :first

    assert_text "Secret key was successfully destroyed"
  end
end
