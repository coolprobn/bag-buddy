class Expense < ApplicationRecord
  enum :category, rent: "rent", ads: "ads", packaging: "packaging", misc: "misc"

  validates :category, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      amount
      category
      created_at
      description
      id
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
