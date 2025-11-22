class DashboardController < AuthenticatedController
  def index
    # Revenue metrics
    @today_revenue = Sale.where(created_at: Date.current.all_day).sum(:total) || 0
    @week_revenue = Sale.where(created_at: Date.current.beginning_of_week..Date.current.end_of_week).sum(:total) || 0
    @month_revenue = Sale.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).sum(:total) || 0
    @year_revenue = Sale.where(created_at: Date.current.beginning_of_year..Date.current.end_of_year).sum(:total) || 0

    # Profit metrics
    @today_profit = Sale.where(created_at: Date.current.all_day).sum(:profit) || 0
    @week_profit = Sale.where(created_at: Date.current.beginning_of_week..Date.current.end_of_week).sum(:profit) || 0
    @month_profit = Sale.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).sum(:profit) || 0
    @year_profit = Sale.where(created_at: Date.current.beginning_of_year..Date.current.end_of_year).sum(:profit) || 0

    # Expenses
    @today_expenses = Expense.where(created_at: Date.current.all_day).sum(:amount) || 0
    @month_expenses = Expense.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount) || 0

    # Top selling products (by quantity sold)
    @top_products = Product.joins(:sales)
                           .select("products.*, SUM(sales.quantity) as total_sold")
                           .group("products.id")
                           .order("total_sold DESC")
                           .limit(5)

    # Top customers (by total spent)
    @top_customers = Customer.joins(:sales)
                            .select("customers.*, SUM(sales.total) as total_spent")
                            .group("customers.id")
                            .order("total_spent DESC")
                            .limit(5)

    # Expense breakdown by category
    @expense_breakdown = Expense.group(:category).sum(:amount)

    # Low stock products
    low_stock_threshold = ApplicationSetting.get("low_stock_threshold") || 1
    @low_stock_products = Product.where("stock_quantity <= ?", low_stock_threshold)
                                 .where(status: "active")
                                 .order(:stock_quantity)
                                 .limit(10)

    # Recent sales
    @recent_sales = Sale.includes(:product, :customer)
                        .order(created_at: :desc)
                        .limit(10)
  end
end
