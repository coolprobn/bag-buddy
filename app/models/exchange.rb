class Exchange < ApplicationRecord
  belongs_to :original_sale, class_name: "Sale"
  belongs_to :replacement_product, class_name: "Product"

  validates :price_difference, numericality: true, allow_nil: true
end
