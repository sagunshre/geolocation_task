class AddIpHostnameAndZipToGeolocation < ActiveRecord::Migration[7.0]
  def change
    add_column :geolocations, :zip, :string
    add_column :geolocations, :ip, :string
    add_column :geolocations, :hostname, :string
  end
end
