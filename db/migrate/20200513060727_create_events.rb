class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :venue, null: false
      t.text :content, null: false
      t.datetime :datetime, null: false
      t.string :image
      t.timestamps
    end
  end
end
