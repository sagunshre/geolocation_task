require "open-uri"

class Ipstack
  attr_accessor :response
  def initialize(base_url=ENV["BASE_URL"], api_key=ENV["ACCESS_KEY"])
    @url = base_url
    @key = api_key
    @response = nil
  end

  def lookup(param)
    ip = ERB::Util.url_encode(param)
    @url += param
    @url += "?access_key=" + @key
    @url += "&language=en"
    @url += "&hostname=1"
    resp = URI.parse(@url).read
    @response = JSON.parse(resp)
  end
end
