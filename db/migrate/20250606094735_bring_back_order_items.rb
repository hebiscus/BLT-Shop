class BringBackOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :sandwich, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.integer :charged_price, null: false, default: 0

      t.timestamps
    end
  end
end
