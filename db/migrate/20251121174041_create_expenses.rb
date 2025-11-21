class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.string :category, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.text :description

      t.timestamps
    end
  end
end
