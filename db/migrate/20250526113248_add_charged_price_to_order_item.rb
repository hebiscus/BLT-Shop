class AddChargedPriceToOrderItem < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :charged_price, :integer, null: false, default: 0
  end
end
