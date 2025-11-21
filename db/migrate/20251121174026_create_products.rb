class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.string :category
      t.integer :stock_quantity, null: false, default: 0
      t.decimal :current_cost_price, precision: 10, scale: 2, null: false
      t.references :current_vendor,
                   null: true,
                   foreign_key: {
                     to_table: :vendors
                   }
      t.decimal :auto_suggested_selling_price, precision: 10, scale: 2
      t.string :status, default: "active", null: false

      t.timestamps
    end
  end
end
