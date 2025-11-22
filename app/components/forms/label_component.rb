class Forms::LabelComponent < ViewComponent::Base
  def initialize(form:, field:, text: nil, class: "", **html_options)
    @form = form
    @field = field
    @text = text
    @additional_classes = binding.local_variable_get(:class)
    @html_options = html_options
  end

  private

  attr_reader :form, :field, :text, :additional_classes, :html_options

  def label_classes
    classes = ["block text-sm font-medium text-primary-700 mb-2"]
    classes << additional_classes if additional_classes.present?
    classes.compact.join(" ")
  end
end
