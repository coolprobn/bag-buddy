require "application_system_test_case"

class CustomersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @customer = customers(:one)
    sign_in @user
  end

  test "visiting the customers index" do
    visit customers_url
    assert_selector "h1", text: "Customers"
  end

  test "visiting the new customer page" do
    visit new_customer_url
    assert_selector "h1", text: "New Customer"
  end

  test "visiting the customer show page" do
    visit customer_url(@customer)
    assert_selector "h1", text: @customer.full_name
  end

  test "visiting the customer edit page" do
    visit edit_customer_url(@customer)
    assert_selector "h1", text: "Edit Customer"
  end
end
