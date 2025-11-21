class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :phone
      t.text :address
      t.text :notes

      t.timestamps
    end
  end
end
