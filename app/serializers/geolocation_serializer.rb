class GeolocationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :continent, :country, :region, :city, :latitude, :longitude, :zip, :ip, :hostname, :created_at, :updated_at
  attributes :device_identifier do |object|
    object.device.identifier
  end
  belongs_to :device, record_type: :device
end
