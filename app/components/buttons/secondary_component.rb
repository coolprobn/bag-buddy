class Buttons::SecondaryComponent < ViewComponent::Base
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
      "bg-secondary-300 text-secondary-800 font-semibold rounded-lg hover:bg-secondary-400 transition-colors focus:outline-none focus:ring-2 focus:ring-secondary-500 focus:ring-offset-2 cursor-pointer"
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
