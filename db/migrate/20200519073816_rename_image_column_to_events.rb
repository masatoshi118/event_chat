class RenameImageColumnToEvents < ActiveRecord::Migration[6.0]
  def change
    rename_column :events, :image, :event_image

  end
end
