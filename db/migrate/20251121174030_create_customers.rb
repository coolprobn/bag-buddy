class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.string :email
      t.string :instagram_profile_url
      t.string :tiktok_profile_url
      t.string :facebook_url
      t.string :whatsapp_number
      t.text :address
      t.text :notes

      t.timestamps
    end
  end
end
