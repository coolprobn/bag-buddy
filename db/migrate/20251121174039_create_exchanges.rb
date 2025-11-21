class CreateExchanges < ActiveRecord::Migration[8.1]
  def change
    create_table :exchanges do |t|
      t.references :original_sale,
                   null: false,
                   foreign_key: {
                     to_table: :sales
                   }
      t.references :replacement_product,
                   null: false,
                   foreign_key: {
                     to_table: :products
                   }
      t.decimal :price_difference
      t.text :notes

      t.timestamps
    end
  end
end
