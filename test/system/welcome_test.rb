require "test_helper"

class WelcomeTest < ApplicationSystemTestCase
  test "welcome page loads" do
    visit root_path
    assert_selector "h1", text: "Bag Buddy"
  end
end
