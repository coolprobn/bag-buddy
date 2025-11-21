class Product < ApplicationRecord
  has_many_attached :images

  belongs_to :current_vendor, class_name: "Vendor", optional: true

  has_many :vendor_price_histories, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :exchanges, foreign_key: :replacement_product_id, dependent: :destroy

  enum :status, active: "active", draft: "draft", archived: "archived"

  validates :name, presence: true
  validates :stock_quantity,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }
  validates :current_cost_price,
            presence: true,
            numericality: {
              greater_than: 0
            }
  validates :auto_suggested_selling_price,
            numericality: {
              greater_than: 0
            },
            allow_nil: true
end
