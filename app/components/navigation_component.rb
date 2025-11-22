class NavigationComponent < ViewComponent::Base
  def initialize(current_user:, current_path: nil)
    @current_user = current_user
    @current_path = current_path
  end

  private

  attr_reader :current_user, :current_path

  def nav_items
    [
      { name: "Dashboard", path: dashboard_path, icon: "📊" },
      { name: "Vendors", path: vendors_path, icon: "🏪" },
      { name: "Products", path: products_path, icon: "👜" },
      { name: "Customers", path: customers_path, icon: "👥" }
    ]
  end

  def active?(path)
    return false unless current_path
    current_path == path || current_path.start_with?(path + "/")
  end
end
