class RemoveUrlFromDevice < ActiveRecord::Migration[7.0]
  def change
    remove_column :devices, :url
  end
end
