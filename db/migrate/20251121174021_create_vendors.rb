class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :phone
      t.text :address
      t.string :instagram_profile_url
      t.string :tiktok_profile_url
      t.string :facebook_url
      t.string :whatsapp_number
      t.text :notes

      t.timestamps
    end
  end
end
