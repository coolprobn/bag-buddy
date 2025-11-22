require "application_system_test_case"

class ApplicationSettingsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @application_setting = application_settings(:one)
    sign_in @user
  end

  test "visiting the application_settings index" do
    visit application_settings_url
    assert_selector "h1", text: "Application Settings"
  end

  test "visiting the new application_setting page" do
    visit new_application_setting_url
    assert_selector "h1", text: "New Setting"
  end

  test "visiting the application_setting show page" do
    visit application_setting_url(@application_setting)
    assert_selector "h1", text: "Setting Details"
  end

  test "visiting the application_setting edit page" do
    visit edit_application_setting_url(@application_setting)
    assert_selector "h1", text: "Edit Setting"
  end
end
