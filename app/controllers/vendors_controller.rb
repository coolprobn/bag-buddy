class VendorsController < AuthenticatedController
  before_action :set_vendor, only: %i[edit update destroy]

  def index
    @q = Vendor.ransack(params[:q])
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    @pagy, @vendors = pagy(@q.result, items: 20)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to vendors_path, notice: "Vendor was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @vendor.update(vendor_params)
      redirect_to vendors_path, notice: "Vendor was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vendor.destroy
    redirect_to vendors_path, notice: "Vendor was successfully deleted."
  end

  private

  def set_vendor
    @vendor = Vendor.find_by_obfuscated_id(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(
      :name,
      :phone,
      :address,
      :instagram_profile_url,
      :tiktok_profile_url,
      :facebook_url,
      :whatsapp_number,
      :notes
    )
  end
end
