class ApplicationSetting < ApplicationRecord
  enum :field_type,
       number_field: "number_field",
       text_field: "text_field",
       boolean_field: "boolean_field"

  validates :key, presence: true, uniqueness: true
  validates :field_type, presence: true
  validate :validate_value_by_field_type

  def parsed_value
    case field_type
    when "number_field"
      value.include?(".") ? value.to_f : value.to_i
    when "boolean_field"
      ActiveModel::Type::Boolean.new.cast(value)
    when "text_field"
      value
    else
      value
    end
  end

  def self.get(key)
    find_by(key: key)&.parsed_value
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at description field_type id key updated_at value]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_value_by_field_type
    return if value.blank?

    case field_type
    when "number_field"
      errors.add(:value, "must be a valid number") unless numeric_string?(value)
    when "boolean_field"
      unless %w[true false 1 0].include?(value.to_s.downcase)
        errors.add(:value, "must be true or false")
      end
    when "text_field"
      # Text fields are always valid as strings
    end
  end

  def numeric_string?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end
end
