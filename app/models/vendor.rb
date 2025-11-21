class Vendor < ApplicationRecord
  has_many :products, foreign_key: :current_vendor_id, dependent: :nullify
  has_many :vendor_price_histories, dependent: :destroy

  validates :name, presence: true
end
