class AddStatusToOrder < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE order_status AS ENUM ('pending', 'confirmed', 'in_progress', 'out_for_delivery', 'delivered','cancelled');
    SQL

    add_column :orders, :order_status, :order_status, default: "pending", null: false
  end

  def down
    remove_column :orders, :order_status
    execute <<-SQL
      DROP TYPE order_status;
    SQL
  end
end
