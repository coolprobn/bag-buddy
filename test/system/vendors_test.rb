require "application_system_test_case"

class VendorsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @vendor = vendors(:one)
    sign_in @user
  end

  test "visiting the vendors index" do
    visit vendors_url
    assert_selector "h1", text: "Vendors"
  end

  test "visiting the new vendor page" do
    visit new_vendor_url
    assert_selector "h1", text: "New Vendor"
  end

  test "visiting the vendor edit page" do
    visit edit_vendor_url(@vendor)
    assert_selector "h1", text: "Edit Vendor"
  end
end
