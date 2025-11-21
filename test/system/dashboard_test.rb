require "test_helper"

class DashboardTest < ApplicationSystemTestCase
  setup do
    @user = users(:admin)
  end

  test "dashboard page loads" do
    sign_in @user
    visit dashboard_path
    assert_selector "h1", text: "Dashboard"
  end
end
