require "application_system_test_case"

class ExpensesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @expense = expenses(:one)
    sign_in @user
  end

  test "visiting the expenses index" do
    visit expenses_url
    assert_selector "h1", text: "Expenses"
  end

  test "visiting the new expense page" do
    visit new_expense_url
    assert_selector "h1", text: "New Expense"
  end

  test "visiting the expense show page" do
    visit expense_url(@expense)
    assert_selector "h1", text: "Expense Details"
  end

  test "visiting the expense edit page" do
    visit edit_expense_url(@expense)
    assert_selector "h1", text: "Edit Expense"
  end
end
