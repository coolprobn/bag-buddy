require "application_system_test_case"

class ExchangesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @exchange = exchanges(:one)
    sign_in @user
  end

  test "visiting the exchanges index" do
    visit exchanges_url
    assert_selector "h1", text: "Exchanges"
  end

  test "visiting the new exchange page" do
    visit new_exchange_url
    assert_selector "h1", text: "New Exchange"
  end

  test "visiting the exchange show page" do
    visit exchange_url(@exchange)
    assert_selector "h1", text: "Exchange Details"
  end

  test "visiting the exchange edit page" do
    visit edit_exchange_url(@exchange)
    assert_selector "h1", text: "Edit Exchange"
  end
end
