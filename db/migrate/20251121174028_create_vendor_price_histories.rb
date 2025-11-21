class CreateVendorPriceHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :vendor_price_histories do |t|
      t.references :product, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.decimal :cost_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
