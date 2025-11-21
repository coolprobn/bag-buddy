class CreateDeliveryPartners < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_partners do |t|
      t.string :name, null: false
      t.decimal :default_cost, precision: 10, scale: 2
      t.string :contact_number
      t.text :notes

      t.timestamps
    end
  end
end
