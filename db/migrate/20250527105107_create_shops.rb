class CreateShops < ActiveRecord::Migration[8.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.jsonb :address, default: {}, null: false

      t.timestamps
    end
    add_index :shops, :address, using: :gin
  end
end
