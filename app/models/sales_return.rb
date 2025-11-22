class SalesReturn < ApplicationRecord
  belongs_to :sale

  validates :return_quantity, presence: true, numericality: { greater_than: 0 }
  validates :refund_amount,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
  validate :return_quantity_not_exceeding_sale_quantity

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      id
      reason
      refund_amount
      return_quantity
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[sale]
  end

  private

  def return_quantity_not_exceeding_sale_quantity
    return unless sale.present? && return_quantity.present?

    total_returned = sale.sales_returns.where.not(id: id).sum(:return_quantity)
    available_to_return = sale.quantity - total_returned

    if return_quantity > available_to_return
      errors.add(:return_quantity, "cannot exceed available quantity to return (#{available_to_return} available)")
    end
  end
end
