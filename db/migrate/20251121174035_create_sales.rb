class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :delivery_partner,
                   null: true,
                   foreign_key: {
                     to_table: :delivery_partners
                   }

      t.decimal :selling_price, precision: 10, scale: 2, null: false
      t.integer :quantity, default: 1, null: false
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0
      t.decimal :tax_amount, precision: 10, scale: 2, default: 0
      t.decimal :delivery_cost, precision: 10, scale: 2, default: 0
      t.decimal :total, precision: 10, scale: 2
      t.decimal :profit, precision: 10, scale: 2

      t.string :payment_method, null: false

      t.text :notes

      t.timestamps
    end
  end
end
