class DeleteOrderItems < ActiveRecord::Migration[8.0]
  def change
    drop_table :order_items
  end
end
