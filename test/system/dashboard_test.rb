require "test_helper"

class DashboardTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "dashboard page loads" do
    login_as @user
    visit dashboard_path
    assert_selector "h1", text: "Dashboard"
  end
end
