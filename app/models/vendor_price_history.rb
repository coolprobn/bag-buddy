class VendorPriceHistory < ApplicationRecord
  belongs_to :product
  belongs_to :vendor

  validates :cost_price, presence: true, numericality: { greater_than: 0 }
end
