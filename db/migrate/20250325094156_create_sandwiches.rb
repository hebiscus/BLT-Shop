class CreateSandwiches < ActiveRecord::Migration[8.0]
  def change
    create_table :sandwiches do |t|
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end
    add_index :sandwiches, :name
  end
end
