class CreateSalesReturns < ActiveRecord::Migration[8.1]
  def change
    create_table :sales_returns do |t|
      t.references :sale, null: false, foreign_key: true
      t.integer :return_quantity, null: false
      t.decimal :refund_amount, precision: 10, scale: 2
      t.text :reason

      t.timestamps
    end
  end
end
