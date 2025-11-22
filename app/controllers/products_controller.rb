class ProductsController < AuthenticatedController
  before_action :set_product,
                only: %i[show edit update destroy purge_attachment]

  def index
    @q = Product.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @products = pagy(@q.result, items: 20)
    @vendors = Vendor.all.order(:name)
  end

  def show
  end

  def new
    @product = Product.new
    @vendors = Vendor.all.order(:name)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Product was successfully created."
    else
      @vendors = Vendor.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @vendors = Vendor.all.order(:name)
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product was successfully updated."
    else
      @vendors = Vendor.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    redirect_to products_path, notice: "Product was successfully deleted."
  end

  def purge_attachment
    attachment = ActiveStorage::Attachment.find_by(id: params[:attachment_id])
    attachment.purge if attachment && attachment.record == @product
    redirect_to edit_product_path(@product),
                notice: "Image was successfully removed."
  end

  private

  def set_product
    @product = Product.find_by_obfuscated_id(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :category,
      :stock_quantity,
      :current_cost_price,
      :auto_suggested_selling_price,
      :current_vendor_id,
      :status,
      images: []
    )
  end
end
