class AddShopToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :shop, null: false, foreign_key: true
  end
end
