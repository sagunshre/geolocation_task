require "open-uri"

class Geolocation
  def initialize(base_url=ENV["BASE_URL"], api_key=ENV["ACCESS_KEY"])
    @base = base_url
    @key = api_key
  end

  def lookup(ip)
    ip = ERB::Util.url_encode(ip)
    url = @base
    url += ip
    url += "?access_key=" + @key
    url += "&language=en"
    url += "&hostname=1"
    data = URI.parse(url).read
    data = JSON.parse(data)
    data
  end
end
