class Expense < ApplicationRecord
  enum :category, rent: "rent", ads: "ads", packaging: "packaging", misc: "misc"

  validates :category, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
