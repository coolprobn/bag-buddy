class CustomersController < AuthenticatedController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @q = Customer.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @customers = pagy(@q.result, items: 20)
  end

  def show
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to customers_path, notice: "Customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: "Customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "Customer was successfully deleted."
  end

  private

  def set_customer
    @customer = Customer.find_by_obfuscated_id(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :first_name,
      :last_name,
      :phone,
      :email,
      :instagram_profile_url,
      :tiktok_profile_url,
      :facebook_url,
      :whatsapp_number,
      :address,
      :notes
    )
  end
end
