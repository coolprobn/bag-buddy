class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :customer
  belongs_to :delivery_partner, optional: true
  has_many :sales_returns, dependent: :destroy
  has_many :exchanges, foreign_key: :original_sale_id, dependent: :destroy

  enum :payment_method,
       cash: "cash",
       card: "card",
       online: "online",
       bank_transfer: "bank_transfer",
       other: "other"

  validates :selling_price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :subtotal,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
  validates :discount_amount,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
  validates :tax_amount,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
  validates :delivery_cost,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
  validates :total,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
  validates :profit, numericality: true, allow_nil: true

  before_save :calculate_amounts

  def discount_percentage
    return 0 if subtotal.blank? || discount_amount.blank?

    ((discount_amount / subtotal) * 100).round(2)
  end

  private

  def calculate_amounts
    # Calculate subtotal (price * quantity before discount)
    self.subtotal = (selling_price * quantity).round(2)

    # Calculate total (subtotal - discount + tax + delivery_cost)
    self.total =
      (
        subtotal - (discount_amount || 0) + (tax_amount || 0) +
          (delivery_cost || 0)
      ).round(2)

    # Recalculate profit (total - cost - delivery_cost - tax)
    cost_total = (product.current_cost_price * quantity)
    self.profit =
      (total - cost_total - (delivery_cost || 0) - (tax_amount || 0)).round(2)
  end
end
