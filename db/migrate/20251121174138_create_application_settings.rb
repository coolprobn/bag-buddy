class CreateApplicationSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :application_settings do |t|
      t.string :key, null: false
      t.text :description
      t.string :field_type, null: false
      t.text :value

      t.timestamps
    end
    add_index :application_settings, :key, unique: true
  end
end
