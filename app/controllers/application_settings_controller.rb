class ApplicationSettingsController < AuthenticatedController
  before_action :set_application_setting, only: %i[show edit update destroy]

  def index
    @q = ApplicationSetting.ransack(params[:q])
    @q.sorts = ["key asc"] if @q.sorts.empty?
    @pagy, @application_settings = pagy(@q.result, items: 20)
  end

  def show
  end

  def new
    @application_setting = ApplicationSetting.new
  end

  def create
    @application_setting = ApplicationSetting.new(application_setting_params)

    if @application_setting.save
      redirect_to application_settings_path,
                  notice: "Setting was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @application_setting.update(application_setting_params)
      redirect_to application_settings_path,
                  notice: "Setting was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @application_setting.destroy
    redirect_to application_settings_path,
                notice: "Setting was successfully deleted."
  end

  private

  def set_application_setting
    @application_setting = ApplicationSetting.find_by_obfuscated_id(params[:id])
  end

  def application_setting_params
    params.require(:application_setting).permit(
      :key,
      :value,
      :field_type,
      :description
    )
  end
end
