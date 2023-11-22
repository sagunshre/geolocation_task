class AddDeviceReferenceToGeolocation < ActiveRecord::Migration[7.0]
  def change
    add_reference :geolocations, :device, foreign_key: true
  end
end
