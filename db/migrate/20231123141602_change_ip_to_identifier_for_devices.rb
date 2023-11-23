class ChangeIpToIdentifierForDevices < ActiveRecord::Migration[7.0]
  def change
    rename_column :devices, :ip, :identifier
  end
end
