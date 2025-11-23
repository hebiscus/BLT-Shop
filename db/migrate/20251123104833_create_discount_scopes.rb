class CreateDiscountScopes < ActiveRecord::Migration[7.1]
  def change
    create_table :discount_scopes do |t|
      t.references :discount, null: false, foreign_key: true
      t.references :shop, foreign_key: true
      t.timestamps
    end

    add_index :discount_scopes, [:discount_id, :shop_id], unique: true
  end
end
