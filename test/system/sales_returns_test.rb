require "application_system_test_case"

class SalesReturnsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @sales_return = sales_returns(:one)
    sign_in @user
  end

  test "visiting the sales_returns index" do
    visit sales_returns_url
    assert_selector "h1", text: "Sales Returns"
  end

  test "visiting the new sales_return page" do
    visit new_sales_return_url
    assert_selector "h1", text: "New Return"
  end

  test "visiting the sales_return show page" do
    visit sales_return_url(@sales_return)
    assert_selector "h1", text: "Return Details"
  end

  test "visiting the sales_return edit page" do
    visit edit_sales_return_url(@sales_return)
    assert_selector "h1", text: "Edit Return"
  end
end
