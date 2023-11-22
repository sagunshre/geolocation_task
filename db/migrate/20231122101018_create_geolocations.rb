class CreateGeolocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocations do |t|
      t.string :continent
      t.string :country, null: false
      t.string :region
      t.string :city, null: false
      t.decimal :latitude, null: false, precision: 17, scale: 14
      t.decimal :longitude, null: false, precision: 17, scale: 14
      t.timestamps
    end
  end
end
