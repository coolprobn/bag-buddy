class DeliveryPartner < ApplicationRecord
  has_many :sales

  validates :name, presence: true
  validates :default_cost,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
end
