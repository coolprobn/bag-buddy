class DeliveryPartner < ApplicationRecord
  has_many :sales

  validates :name, presence: true
  validates :default_cost,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      contact_number
      created_at
      default_cost
      id
      name
      notes
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[sales]
  end
end
