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

  before_save :track_price_history, if: :should_track_price_history?

  def self.ransackable_attributes(auth_object = nil)
    %w[
      auto_suggested_selling_price
      category
      color_family
      created_at
      current_cost_price
      current_vendor_id
      description
      id
      name
      status
      stock_quantity
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[current_vendor vendor_price_histories sales exchanges]
  end

  private

  def should_track_price_history?
    (current_cost_price_changed? || current_vendor_id_changed?) && persisted? &&
      current_vendor.present? && current_cost_price.present?
  end

  def track_price_history
    # Only track if cost price or vendor actually changed
    if current_cost_price_changed? || current_vendor_id_changed?
      # Check if we already have a history entry for this vendor/product combination today
      existing_history =
        vendor_price_histories
          .where(vendor: current_vendor)
          .where("created_at >= ?", Date.current.beginning_of_day)
          .first

      if existing_history
        # Update existing entry if price changed
        if current_cost_price_changed?
          existing_history.update(cost_price: current_cost_price)
        end
      else
        # Create new history entry
        vendor_price_histories.create!(
          vendor: current_vendor,
          cost_price: current_cost_price
        )
      end
    end
  end
end
