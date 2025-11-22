class StatCardComponent < ViewComponent::Base
  def initialize(label:, value:, subtitle: nil)
    @label = label
    @value = value
    @subtitle = subtitle
  end

  private

  attr_reader :label, :value, :subtitle
end
