class ReportsController < AuthenticatedController
  def index
    # Default to current month if no dates provided
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current.end_of_month

    # Sales report data
    @sales = Sale.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
    @total_revenue = @sales.sum(:total) || 0
    @total_profit = @sales.sum(:profit) || 0
    @total_sales_count = @sales.count
    @average_sale_amount = @total_sales_count > 0 ? (@total_revenue / @total_sales_count) : 0

    # Payment method breakdown
    @payment_method_breakdown = @sales.group(:payment_method).sum(:total)

    # Top products by revenue
    @top_products_by_revenue = Product.joins(:sales)
                                      .where(sales: { created_at: @start_date.beginning_of_day..@end_date.end_of_day })
                                      .select("products.*, SUM(sales.total) as revenue, SUM(sales.quantity) as units_sold")
                                      .group("products.id")
                                      .order("revenue DESC")
                                      .limit(10)

    # Top customers by spending
    @top_customers_by_spending = Customer.joins(:sales)
                                         .where(sales: { created_at: @start_date.beginning_of_day..@end_date.end_of_day })
                                         .select("customers.*, SUM(sales.total) as total_spent, COUNT(sales.id) as purchase_count")
                                         .group("customers.id")
                                         .order("total_spent DESC")
                                         .limit(10)

    # Expense report data
    @expenses = Expense.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
    @total_expenses = @expenses.sum(:amount) || 0
    @expense_breakdown = @expenses.group(:category).sum(:amount)

    # Net profit
    @net_profit = @total_profit - @total_expenses

    # Daily revenue trend (last 30 days or selected range)
    days_range = [(@end_date - @start_date).to_i, 30].min
    daily_sales = Sale.where(created_at: (@end_date - days_range.days).beginning_of_day..@end_date.end_of_day)
    @daily_revenue = daily_sales.group_by { |sale| sale.created_at.to_date }
                                 .transform_values { |sales| sales.sum { |s| s.total || 0 } }
                                 .sort
  end

  def export
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current.end_of_month
    @report_type = params[:report_type] || "sales"

    respond_to do |format|
      format.xlsx do
        if @report_type == "sales"
          export_sales_report
        elsif @report_type == "expenses"
          export_expenses_report
        else
          redirect_to reports_path, alert: "Invalid report type"
        end
      end
    end
  end

  private

  def export_sales_report
    sales = Sale.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
                .includes(:product, :customer, :delivery_partner)

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Sales Report") do |sheet|
      # Header
      sheet.add_row(["Sales Report", nil, nil, nil, nil, nil])
      sheet.add_row(["Period", "#{@start_date} to #{@end_date}", nil, nil, nil, nil])
      sheet.add_row([])

      # Summary
      sheet.add_row(["Summary", nil, nil, nil, nil, nil])
      sheet.add_row(["Total Revenue", sales.sum(:total), nil, nil, nil, nil])
      sheet.add_row(["Total Profit", sales.sum(:profit), nil, nil, nil, nil])
      sheet.add_row(["Total Sales", sales.count, nil, nil, nil, nil])
      sheet.add_row([])

      # Sales details
      sheet.add_row(["Date", "Product", "Customer", "Quantity", "Total", "Profit", "Payment Method"])
      sales.each do |sale|
        sheet.add_row([
          sale.created_at.strftime("%Y-%m-%d"),
          sale.product.name,
          sale.customer.full_name,
          sale.quantity,
          sale.total,
          sale.profit,
          sale.payment_method.humanize
        ])
      end
    end

    send_data package.to_stream.read,
              filename: "sales_report_#{@start_date}_to_#{@end_date}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_expenses_report
    expenses = Expense.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Expenses Report") do |sheet|
      # Header
      sheet.add_row(["Expenses Report", nil, nil, nil])
      sheet.add_row(["Period", "#{@start_date} to #{@end_date}", nil, nil])
      sheet.add_row([])

      # Summary
      sheet.add_row(["Summary", nil, nil, nil])
      sheet.add_row(["Total Expenses", expenses.sum(:amount), nil, nil])
      sheet.add_row([])

      # Category breakdown
      sheet.add_row(["Category Breakdown", nil, nil, nil])
      expenses.group(:category).sum(:amount).each do |category, amount|
        sheet.add_row([category.humanize, amount, nil, nil])
      end
      sheet.add_row([])

      # Expense details
      sheet.add_row(["Date", "Category", "Amount", "Description"])
      expenses.each do |expense|
        sheet.add_row([
          expense.created_at.strftime("%Y-%m-%d"),
          expense.category.humanize,
          expense.amount,
          expense.description
        ])
      end
    end

    send_data package.to_stream.read,
              filename: "expenses_report_#{@start_date}_to_#{@end_date}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end
end
