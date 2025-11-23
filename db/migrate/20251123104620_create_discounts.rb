class CreateDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :discounts do |t|
      t.string :name, null: false
      t.integer :percentage, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :active, default: true
      t.jsonb :rules, default: {}
      t.timestamps
    end

    add_index :discounts, :active
    add_index :discounts, :starts_at
    add_index :discounts, :ends_at
  end
end
