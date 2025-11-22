require "application_system_test_case"

class SalesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @sale = sales(:one)
    sign_in @user
  end

  test "visiting the sales index" do
    visit sales_url
    assert_selector "h1", text: "Sales"
  end

  test "visiting the new sale page" do
    visit new_sale_url
    assert_selector "h1", text: "New Sale"
  end

  test "visiting the sale show page" do
    visit sale_url(@sale)
    assert_selector "h1", text: "Sale Details"
  end

  test "visiting the sale edit page" do
    visit edit_sale_url(@sale)
    assert_selector "h1", text: "Edit Sale"
  end
end
