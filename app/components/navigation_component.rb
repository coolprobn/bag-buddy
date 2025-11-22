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
      { name: "Products", path: products_path, icon: "👜" },
      { name: "Sales", path: sales_path, icon: "💰" },
      { name: "Customers", path: customers_path, icon: "👥" }
    ]
  end

  def dropdown_items
    [
      {
        group: "Sales Operations",
        items: [
          { name: "Returns", path: sales_returns_path, icon: "↩️" },
          { name: "Exchanges", path: exchanges_path, icon: "🔄" }
        ]
      },
      {
        group: "Management",
        items: [
          { name: "Vendors", path: vendors_path, icon: "🏪" },
          { name: "Expenses", path: expenses_path, icon: "💸" }
        ]
      },
      {
        group: "Analytics",
        items: [
          { name: "Reports", path: reports_path, icon: "📊" }
        ]
      }
    ]
  end

  def active?(path)
    return false unless current_path
    current_path == path || current_path.start_with?(path + "/")
  end
end
