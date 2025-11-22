class Buttons::PrimaryComponent < ViewComponent::Base
  SIZES = {
    sm: "py-2 px-4 text-sm",
    md: "py-3 px-6 text-base",
    lg: "py-4 px-8 text-lg"
  }.freeze

  def initialize(
    href: nil,
    method: nil,
    data: {},
    size: :md,
    full_width: false,
    class: "",
    **html_options
  )
    @href = href
    @method = method
    @data = data
    @size = size
    @full_width = full_width
    @additional_classes = binding.local_variable_get(:class)
    @html_options = html_options
  end

  private

  attr_reader :href,
              :method,
              :data,
              :size,
              :full_width,
              :additional_classes,
              :html_options

  def base_classes
    classes = [
      "bg-primary-600 text-white font-semibold rounded-lg hover:bg-primary-700 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 cursor-pointer"
    ]
    classes << "w-full" if full_width
    classes << "inline-block text-center" if href.present? && !full_width
    classes << (SIZES[size] || SIZES[:md])
    classes << additional_classes if additional_classes.present?
    classes.compact.join(" ")
  end

  def link_tag?
    href.present?
  end
end
