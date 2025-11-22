class SalesController < AuthenticatedController
  before_action :set_sale, only: %i[show edit update destroy]

  def index
    @q = Sale.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @sales = pagy(@q.result.includes(:product, :customer, :delivery_partner), items: 20)
  end

  def show
  end

  def new
    @sale = Sale.new
    @products = Product.active.order(:name)
    @customers = Customer.order(:first_name, :last_name)
    @delivery_partners = DeliveryPartner.order(:name)
  end

  def create
    @sale = Sale.new(sale_params)
    @products = Product.active.order(:name)
    @customers = Customer.order(:first_name, :last_name)
    @delivery_partners = DeliveryPartner.order(:name)

    if @sale.save
      # Update product stock
      @sale.product.update(
        stock_quantity: @sale.product.stock_quantity - @sale.quantity
      )
      redirect_to sales_path, notice: "Sale was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @products = Product.active.order(:name)
    @customers = Customer.order(:first_name, :last_name)
    @delivery_partners = DeliveryPartner.order(:name)
  end

  def update
    old_quantity = @sale.quantity
    old_product = @sale.product

    if @sale.update(sale_params)
      # Handle stock updates if product or quantity changed
      if old_product != @sale.product
        # Restore old product stock
        old_product.update(
          stock_quantity: old_product.stock_quantity + old_quantity
        )
        # Deduct new product stock
        @sale.product.update(
          stock_quantity: @sale.product.stock_quantity - @sale.quantity
        )
      elsif old_quantity != @sale.quantity
        # Adjust stock based on quantity difference
        quantity_diff = old_quantity - @sale.quantity
        @sale.product.update(
          stock_quantity: @sale.product.stock_quantity + quantity_diff
        )
      end

      redirect_to sales_path, notice: "Sale was successfully updated."
    else
      @products = Product.active.order(:name)
      @customers = Customer.order(:first_name, :last_name)
      @delivery_partners = DeliveryPartner.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Restore product stock
    @sale.product.update(
      stock_quantity: @sale.product.stock_quantity + @sale.quantity
    )
    @sale.destroy
    redirect_to sales_path, notice: "Sale was successfully deleted."
  end

  private

  def set_sale
    @sale = Sale.find_by_obfuscated_id(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :product_id,
      :customer_id,
      :delivery_partner_id,
      :selling_price,
      :quantity,
      :discount_amount,
      :tax_amount,
      :delivery_cost,
      :payment_method,
      :notes
    )
  end
end
