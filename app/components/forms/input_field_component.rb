class Forms::InputFieldComponent < ViewComponent::Base
  INPUT_TYPES = {
    text: :text_field,
    email: :email_field,
    number: :number_field
  }.freeze

  def initialize(
    form:,
    field:,
    type: :text,
    placeholder: nil,
    autofocus: false,
    readonly: false,
    value: nil,
    class: "",
    **html_options
  )
    @form = form
    @field = field
    @type = type
    @placeholder = placeholder
    @autofocus = autofocus
    @readonly = readonly
    @value = value
    @additional_classes = binding.local_variable_get(:class)
    @html_options = html_options
  end

  private

  attr_reader :form,
              :field,
              :type,
              :placeholder,
              :autofocus,
              :readonly,
              :value,
              :additional_classes,
              :html_options

  def input_classes
    classes = [
      "w-full px-4 py-3 border border-secondary-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none transition-colors"
    ]
    classes << "bg-secondary-50" if readonly
    classes << additional_classes if additional_classes.present?
    classes.compact.join(" ")
  end

  def input_method
    INPUT_TYPES[type] || :text_field
  end

  def input_options
    options = { class: input_classes, **html_options }
    options[:placeholder] = placeholder if placeholder.present?
    options[:autofocus] = true if autofocus
    options[:readonly] = true if readonly
    options[:value] = value if value.present?
    options
  end
end
