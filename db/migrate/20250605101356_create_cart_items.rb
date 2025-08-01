class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :sandwich, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.integer :charged_price, null: false, default: 0

      t.timestamps
    end
  end
end
