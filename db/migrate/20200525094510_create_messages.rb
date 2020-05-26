class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id, null: false
      t.references :event, null: false, foreign_key: true
      t.timestamps
    end
  end
end
