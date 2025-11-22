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

  def bulk_export
    package = Axlsx::Package.new
    workbook = package.workbook

    # Products Sheet
    workbook.add_worksheet(name: "Products") do |sheet|
      sheet.add_row(["ID", "Name", "Description", "Category", "Stock Quantity", "Cost Price", "Suggested Price", "Vendor", "Status", "Created At"])
      Product.includes(:current_vendor).find_each do |product|
        sheet.add_row([
          product.id,
          product.name,
          product.description,
          product.category,
          product.stock_quantity,
          product.current_cost_price,
          product.auto_suggested_selling_price,
          product.current_vendor&.name,
          product.status,
          product.created_at
        ])
      end
    end

    # Vendors Sheet
    workbook.add_worksheet(name: "Vendors") do |sheet|
      sheet.add_row(["ID", "Name", "Phone", "Address", "Notes", "Created At"])
      Vendor.find_each do |vendor|
        sheet.add_row([
          vendor.id,
          vendor.name,
          vendor.phone,
          vendor.address,
          vendor.notes,
          vendor.created_at
        ])
      end
    end

    # Customers Sheet
    workbook.add_worksheet(name: "Customers") do |sheet|
      sheet.add_row(["ID", "Full Name", "Phone", "Email", "Address", "Instagram", "TikTok", "Facebook", "WhatsApp", "Notes", "Created At"])
      Customer.find_each do |customer|
        sheet.add_row([
          customer.id,
          customer.full_name,
          customer.phone,
          customer.email,
          customer.address,
          customer.instagram_profile_url,
          customer.tiktok_profile_url,
          customer.facebook_url,
          customer.whatsapp_number,
          customer.notes,
          customer.created_at
        ])
      end
    end

    # Sales Sheet
    workbook.add_worksheet(name: "Sales") do |sheet|
      sheet.add_row(["ID", "Date", "Product", "Customer", "Quantity", "Selling Price", "Subtotal", "Discount", "Tax", "Delivery Cost", "Total", "Profit", "Payment Method", "Delivery Partner", "Notes"])
      Sale.includes(:product, :customer, :delivery_partner).find_each do |sale|
        sheet.add_row([
          sale.id,
          sale.created_at,
          sale.product.name,
          sale.customer.full_name,
          sale.quantity,
          sale.selling_price,
          sale.subtotal,
          sale.discount_amount,
          sale.tax_amount,
          sale.delivery_cost,
          sale.total,
          sale.profit,
          sale.payment_method.humanize,
          sale.delivery_partner&.name,
          sale.notes
        ])
      end
    end

    # Returns Sheet
    workbook.add_worksheet(name: "Returns") do |sheet|
      sheet.add_row(["ID", "Sale ID", "Product", "Customer", "Return Quantity", "Refund Amount", "Reason", "Created At"])
      SalesReturn.includes(sale: [:product, :customer]).find_each do |return_item|
        sheet.add_row([
          return_item.id,
          return_item.sale_id,
          return_item.sale.product.name,
          return_item.sale.customer.full_name,
          return_item.return_quantity,
          return_item.refund_amount,
          return_item.reason,
          return_item.created_at
        ])
      end
    end

    # Exchanges Sheet
    workbook.add_worksheet(name: "Exchanges") do |sheet|
      sheet.add_row(["ID", "Original Sale", "Original Product", "Replacement Product", "Price Difference", "Notes", "Created At"])
      Exchange.includes(original_sale: [:product, :customer], replacement_product: :current_vendor).find_each do |exchange|
        sheet.add_row([
          exchange.id,
          exchange.original_sale_id,
          exchange.original_sale.product.name,
          exchange.replacement_product.name,
          exchange.price_difference,
          exchange.notes,
          exchange.created_at
        ])
      end
    end

    # Expenses Sheet
    workbook.add_worksheet(name: "Expenses") do |sheet|
      sheet.add_row(["ID", "Date", "Category", "Amount", "Description", "Created At"])
      Expense.find_each do |expense|
        sheet.add_row([
          expense.id,
          expense.created_at,
          expense.category.humanize,
          expense.amount,
          expense.description,
          expense.created_at
        ])
      end
    end

    # Delivery Partners Sheet
    workbook.add_worksheet(name: "Delivery Partners") do |sheet|
      sheet.add_row(["ID", "Name", "Default Cost", "Contact", "Notes", "Created At"])
      DeliveryPartner.find_each do |partner|
        sheet.add_row([
          partner.id,
          partner.name,
          partner.default_cost,
          partner.contact_number,
          partner.notes,
          partner.created_at
        ])
      end
    end

    # Vendor Price History Sheet
    workbook.add_worksheet(name: "Vendor Price History") do |sheet|
      sheet.add_row(["ID", "Product", "Vendor", "Cost Price", "Date"])
      VendorPriceHistory.includes(:product, :vendor).find_each do |history|
        sheet.add_row([
          history.id,
          history.product.name,
          history.vendor.name,
          history.cost_price,
          history.created_at
        ])
      end
    end

    # Analytics Summary Sheet
    workbook.add_worksheet(name: "Analytics Summary") do |sheet|
      sheet.add_row(["Metric", "Value"])
      
      total_revenue = Sale.sum(:total) || 0
      total_profit = Sale.sum(:profit) || 0
      total_expenses = Expense.sum(:amount) || 0
      net_profit = total_profit - total_expenses
      
      sheet.add_row(["Total Revenue (All Time)", total_revenue])
      sheet.add_row(["Total Profit (All Time)", total_profit])
      sheet.add_row(["Total Expenses (All Time)", total_expenses])
      sheet.add_row(["Net Profit (All Time)", net_profit])
      sheet.add_row([])
      
      sheet.add_row(["Total Products", Product.count])
      sheet.add_row(["Active Products", Product.where(status: "active").count])
      sheet.add_row(["Total Vendors", Vendor.count])
      sheet.add_row(["Total Customers", Customer.count])
      sheet.add_row(["Total Sales", Sale.count])
      sheet.add_row(["Total Returns", SalesReturn.count])
      sheet.add_row(["Total Exchanges", Exchange.count])
      sheet.add_row([])
      
      # Top 10 Products by Revenue
      sheet.add_row(["Top 10 Products by Revenue"])
      sheet.add_row(["Product", "Revenue", "Units Sold"])
      Product.joins(:sales)
             .select("products.*, SUM(sales.total) as revenue, SUM(sales.quantity) as units_sold")
             .group("products.id")
             .order("revenue DESC")
             .limit(10)
             .each do |product|
        sheet.add_row([product.name, product.revenue, product.units_sold])
      end
      
      sheet.add_row([])
      
      # Top 10 Customers by Spending
      sheet.add_row(["Top 10 Customers by Spending"])
      sheet.add_row(["Customer", "Total Spent", "Purchase Count"])
      Customer.joins(:sales)
              .select("customers.*, SUM(sales.total) as total_spent, COUNT(sales.id) as purchase_count")
              .group("customers.id")
              .order("total_spent DESC")
              .limit(10)
              .each do |customer|
        sheet.add_row([customer.full_name, customer.total_spent, customer.purchase_count])
      end
    end

    send_data package.to_stream.read,
              filename: "bag_buddy_full_export_#{Date.current.strftime('%Y%m%d')}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
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
