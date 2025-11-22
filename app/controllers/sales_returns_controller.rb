class SalesReturnsController < AuthenticatedController
  before_action :set_sales_return, only: %i[show edit update destroy]

  def index
    @q = SalesReturn.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @sales_returns = pagy(@q.result.includes(:sale), items: 20)
  end

  def show
  end

  def new
    @sales_return = SalesReturn.new
    @sales_return.sale = Sale.find_by_obfuscated_id(params[:sale_id]) if params[:sale_id].present?
    @sales = Sale.order(created_at: :desc).limit(100)
  end

  def create
    @sales_return = SalesReturn.new(sales_return_params)
    @sales = Sale.order(created_at: :desc).limit(100)

    if @sales_return.save
      # Restore product stock
      sale = @sales_return.sale
      sale.product.update(
        stock_quantity: sale.product.stock_quantity + @sales_return.return_quantity
      )
      redirect_to sales_returns_path, notice: "Return was successfully processed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @sales = Sale.order(created_at: :desc).limit(100)
  end

  def update
    old_return_quantity = @sales_return.return_quantity
    old_sale = @sales_return.sale

    if @sales_return.update(sales_return_params)
      # Handle stock updates if sale or quantity changed
      if old_sale != @sales_return.sale
        # Restore old sale's product stock
        old_sale.product.update(
          stock_quantity: old_sale.product.stock_quantity + old_return_quantity
        )
        # Deduct new sale's product stock
        @sales_return.sale.product.update(
          stock_quantity: @sales_return.sale.product.stock_quantity - @sales_return.return_quantity
        )
      elsif old_return_quantity != @sales_return.return_quantity
        # Adjust stock based on quantity difference
        quantity_diff = old_return_quantity - @sales_return.return_quantity
        @sales_return.sale.product.update(
          stock_quantity: @sales_return.sale.product.stock_quantity + quantity_diff
        )
      end

      redirect_to sales_returns_path, notice: "Return was successfully updated."
    else
      @sales = Sale.order(created_at: :desc).limit(100)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Restore stock that was added back
    sale = @sales_return.sale
    sale.product.update(
      stock_quantity: sale.product.stock_quantity - @sales_return.return_quantity
    )
    @sales_return.destroy
    redirect_to sales_returns_path, notice: "Return was successfully deleted."
  end

  private

  def set_sales_return
    @sales_return = SalesReturn.find_by_obfuscated_id(params[:id])
  end

  def sales_return_params
    params.require(:sales_return).permit(:sale_id, :return_quantity, :refund_amount, :reason)
  end
end
