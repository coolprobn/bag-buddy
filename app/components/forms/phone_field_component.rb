class Forms::PhoneFieldComponent < ViewComponent::Base
  def initialize(
    form:,
    field:,
    placeholder: "+977 98XXXXXXXX",
    autofocus: false,
    class: "",
    **html_options
  )
    @form = form
    @field = field
    @placeholder = placeholder
    @autofocus = autofocus
    @additional_classes = binding.local_variable_get(:class)
    @html_options = html_options
  end

  private

  attr_reader :form, :field, :placeholder, :autofocus, :additional_classes, :html_options

  def input_classes
    classes = [
      "w-full px-4 py-3 border border-secondary-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none transition-colors"
    ]
    classes << additional_classes if additional_classes.present?
    classes.compact.join(" ")
  end

  def input_options
    options = {
      class: input_classes,
      type: "tel",
      **html_options
    }
    options[:placeholder] = placeholder if placeholder.present?
    options[:autofocus] = true if autofocus
    options
  end
end
