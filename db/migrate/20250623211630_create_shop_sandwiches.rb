class CreateShopSandwiches < ActiveRecord::Migration[8.0]
  def change
    create_table :shop_sandwiches do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :sandwich, null: false, foreign_key: true
      t.timestamps
    end

    add_index :shop_sandwiches, [:shop_id, :sandwich_id], unique: true
  end
end
