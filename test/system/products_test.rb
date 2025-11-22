require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @product = products(:one)
    sign_in @user
  end

  test "visiting the products index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "visiting the new product page" do
    visit new_product_url
    assert_selector "h1", text: "New Product"
  end

  test "visiting the product show page" do
    visit product_url(@product)
    assert_selector "h1", text: @product.name
  end

  test "visiting the product edit page" do
    visit edit_product_url(@product)
    assert_selector "h1", text: "Edit Product"
  end
end
