class CreateOrders < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE TYPE delivery_method AS ENUM ('self_pickup', 'delivery');
    SQL

    create_table :orders do |t|
      t.column :delivery_method, :delivery_method, default: "self_pickup", null: false
      t.datetime :delivery_time, null: false

      t.timestamps
    end
  end

  def down
    drop_table :orders
    execute <<-SQL
      DROP TYPE delivery_method;
    SQL
  end
end
