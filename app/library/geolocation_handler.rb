class GeolocationHandler
  def initialize(ipstack)
    @ipstack = ipstack
    @resp = @ipstack.response
  end

  def store
    if @resp["error"]
      raise IpstackException.new(msg: @resp["error"]["info"], status: @resp["error"]["code"], exception_type: @resp["error"]["type"])
    else
      device = Device.create!(ip: @resp["ip"], url: @resp["hostname"])
      geolocation = Geolocation.new(geolocation_params)
      geolocation.device = device
      geolocation.save!
      return device
    end
  end

  def geolocation_params
    {
      continent: @resp["continent_name"],
      country: @resp["country_name"],
      region: @resp["region_name"],
      city: @resp["city"],
      latitude: @resp["latitude"],
      longitude: @resp["longitude"]
    }
  end
end
