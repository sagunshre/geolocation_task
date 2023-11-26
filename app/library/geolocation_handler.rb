class GeolocationHandler
  def initialize(lookup)
    @lookup = lookup
    @resp = @lookup.response
  end

  def store(identifier)
    if @resp["error"]
      raise LookupException.new(msg: @resp["error"]["info"], status: @resp["error"]["code"], exception_type: @resp["error"]["type"])
    else
      device = Device.create!(identifier: identifier)
      geolocation = Geolocation.new(geolocation_params)
      geolocation.device = device
      geolocation.save!
      return geolocation
    end
  end

  def geolocation_params
    {
      ip: @resp["ip"],
      hostname: @resp["hostname"],
      continent: @resp["continent_name"],
      country: @resp["country_name"],
      region: @resp["region_name"],
      zip: @resp["zip"],
      city: @resp["city"],
      latitude: @resp["latitude"],
      longitude: @resp["longitude"]
    }
  end
end
