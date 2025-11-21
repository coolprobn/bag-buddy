class SalesReturn < ApplicationRecord
  belongs_to :sale

  validates :return_quantity, presence: true, numericality: { greater_than: 0 }
  validates :refund_amount,
            numericality: {
              greater_than_or_equal_to: 0
            },
            allow_nil: true
end
