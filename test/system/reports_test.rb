require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "visiting the reports index" do
    visit reports_url
    assert_selector "h1", text: "Reports & Analytics"
  end

  test "filtering reports by date range" do
    visit reports_url
    fill_in "start_date", with: 1.month.ago.to_date
    fill_in "end_date", with: Date.current
    click_button "Apply Filter"
    assert_selector "h1", text: "Reports & Analytics"
  end
end
