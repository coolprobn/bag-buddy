class DeliveryPartnersController < AuthenticatedController
  before_action :set_delivery_partner, only: %i[show edit update destroy]

  def index
    @q = DeliveryPartner.ransack(params[:q])
    @q.sorts = ["name asc"] if @q.sorts.empty?
    @pagy, @delivery_partners = pagy(@q.result, items: 20)
  end

  def show
  end

  def new
    @delivery_partner = DeliveryPartner.new
  end

  def create
    @delivery_partner = DeliveryPartner.new(delivery_partner_params)

    if @delivery_partner.save
      redirect_to delivery_partners_path, notice: "Delivery partner was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @delivery_partner.update(delivery_partner_params)
      redirect_to delivery_partners_path, notice: "Delivery partner was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @delivery_partner.destroy
    redirect_to delivery_partners_path, notice: "Delivery partner was successfully deleted."
  end

  private

  def set_delivery_partner
    @delivery_partner = DeliveryPartner.find_by_obfuscated_id(params[:id])
  end

  def delivery_partner_params
    params.require(:delivery_partner).permit(:name, :default_cost, :contact_number, :notes)
  end
end
