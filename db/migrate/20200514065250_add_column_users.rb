class AddColumnUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :image, :string, default: 'default_image.png'
    add_column :users, :description, :string

  end
end
