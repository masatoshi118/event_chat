class CreateJoins < ActiveRecord::Migration[6.0]
  def change
    create_table :joins do |t|
      t.integer :user_id, null: false, index: true
      t.integer :event_id, null: false, index: true

      t.timestamps
    end

    add_index :joins, [:user_id, :event_id], unique: true

  end
end