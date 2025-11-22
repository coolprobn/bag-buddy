class Exchange < ApplicationRecord
  belongs_to :original_sale, class_name: "Sale"
  belongs_to :replacement_product, class_name: "Product"

  validates :price_difference, numericality: true, allow_nil: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      id
      notes
      price_difference
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[original_sale replacement_product]
  end
end
