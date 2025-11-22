class CardComponent < ViewComponent::Base
  def initialize(title: nil, hover: false, class: "", body_class: nil)
    @title = title
    @hover = hover
    @additional_classes = binding.local_variable_get(:class)
    @body_class = body_class
  end

  private

  attr_reader :title, :hover, :additional_classes, :body_class

  def card_classes
    classes = ["bg-white rounded-lg shadow"]
    classes << "hover:shadow-lg transition-shadow" if hover
    classes << additional_classes if additional_classes.present?
    classes.compact.join(" ")
  end

  def body_classes
    body_class || "p-6"
  end
end
