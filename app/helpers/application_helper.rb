module ApplicationHelper
  def primary_button_classes(size: :md, class: "")
    component =
      Buttons::PrimaryComponent.new(
        size: size,
        class: binding.local_variable_get(:class)
      )
    component.send(:base_classes)
  end
end
