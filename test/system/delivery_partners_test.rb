require "application_system_test_case"

class DeliveryPartnersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @delivery_partner = delivery_partners(:one)
    sign_in @user
  end

  test "visiting the delivery_partners index" do
    visit delivery_partners_url
    assert_selector "h1", text: "Delivery Partners"
  end

  test "visiting the new delivery_partner page" do
    visit new_delivery_partner_url
    assert_selector "h1", text: "New Delivery Partner"
  end

  test "visiting the delivery_partner show page" do
    visit delivery_partner_url(@delivery_partner)
    assert_selector "h1", text: @delivery_partner.name
  end

  test "visiting the delivery_partner edit page" do
    visit edit_delivery_partner_url(@delivery_partner)
    assert_selector "h1", text: "Edit Delivery Partner"
  end
end
