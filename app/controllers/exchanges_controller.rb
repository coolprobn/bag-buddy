class ExchangesController < AuthenticatedController
  before_action :set_exchange, only: %i[show edit update destroy]

  def index
    @q = Exchange.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @exchanges = pagy(@q.result.includes(:original_sale, :replacement_product), items: 20)
  end

  def show
  end

  def new
    @exchange = Exchange.new
    @exchange.original_sale = Sale.find_by_obfuscated_id(params[:sale_id]) if params[:sale_id].present?
    @sales = Sale.order(created_at: :desc).limit(100)
    @products = Product.active.order(:name)
  end

  def create
    @exchange = Exchange.new(exchange_params)
    @sales = Sale.order(created_at: :desc).limit(100)
    @products = Product.active.order(:name)

    if @exchange.save
      # Calculate and update price difference
      original_price = @exchange.original_sale.selling_price
      replacement_price = @exchange.replacement_product.auto_suggested_selling_price || @exchange.replacement_product.current_cost_price * 1.5
      price_diff = replacement_price - original_price
      @exchange.update(price_difference: price_diff)

      # Update stock: restore original product, deduct replacement product
      @exchange.original_sale.product.update(
        stock_quantity: @exchange.original_sale.product.stock_quantity + @exchange.original_sale.quantity
      )
      @exchange.replacement_product.update(
        stock_quantity: @exchange.replacement_product.stock_quantity - @exchange.original_sale.quantity
      )

      redirect_to exchanges_path, notice: "Exchange was successfully processed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @sales = Sale.order(created_at: :desc).limit(100)
    @products = Product.active.order(:name)
  end

  def update
    old_sale = @exchange.original_sale
    old_replacement = @exchange.replacement_product
    old_quantity = old_sale.quantity

    if @exchange.update(exchange_params)
      # Recalculate price difference
      original_price = @exchange.original_sale.selling_price
      replacement_price = @exchange.replacement_product.auto_suggested_selling_price || @exchange.replacement_product.current_cost_price * 1.5
      price_diff = replacement_price - original_price
      @exchange.update(price_difference: price_diff)

      # Handle stock updates if sale or product changed
      if old_sale != @exchange.original_sale || old_replacement != @exchange.replacement_product
        # Restore old stock
        old_sale.product.update(
          stock_quantity: old_sale.product.stock_quantity + old_quantity
        )
        old_replacement.update(
          stock_quantity: old_replacement.stock_quantity - old_quantity
        )

        # Update new stock
        @exchange.original_sale.product.update(
          stock_quantity: @exchange.original_sale.product.stock_quantity - @exchange.original_sale.quantity
        )
        @exchange.replacement_product.update(
          stock_quantity: @exchange.replacement_product.stock_quantity + @exchange.original_sale.quantity
        )
      end

      redirect_to exchanges_path, notice: "Exchange was successfully updated."
    else
      @sales = Sale.order(created_at: :desc).limit(100)
      @products = Product.active.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Restore stock
    @exchange.original_sale.product.update(
      stock_quantity: @exchange.original_sale.product.stock_quantity + @exchange.original_sale.quantity
    )
    @exchange.replacement_product.update(
      stock_quantity: @exchange.replacement_product.stock_quantity - @exchange.original_sale.quantity
    )
    @exchange.destroy
    redirect_to exchanges_path, notice: "Exchange was successfully deleted."
  end

  private

  def set_exchange
    @exchange = Exchange.find_by_obfuscated_id(params[:id])
  end

  def exchange_params
    params.require(:exchange).permit(:original_sale_id, :replacement_product_id, :notes)
  end
end
