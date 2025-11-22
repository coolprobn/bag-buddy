class Forms::TextAreaFieldComponent < ViewComponent::Base
  def initialize(
    form:,
    field:,
    rows: 4,
    placeholder: nil,
    class: "",
    **html_options
  )
    @form = form
    @field = field
    @rows = rows
    @placeholder = placeholder
    @additional_classes = binding.local_variable_get(:class)
    @html_options = html_options
  end

  private

  attr_reader :form,
              :field,
              :rows,
              :placeholder,
              :additional_classes,
              :html_options

  def textarea_classes
    classes = [
      "w-full px-4 py-3 border border-secondary-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none transition-colors"
    ]
    classes << additional_classes if additional_classes.present?
    classes.compact.join(" ")
  end

  def textarea_options
    options = { class: textarea_classes, rows: rows, **html_options }
    options[:placeholder] = placeholder if placeholder.present?
    options
  end
end
