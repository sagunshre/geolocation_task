class IpstackException < StandardError
  def initialize(msg = "default", status = 0, exception_type = "custom")
    @status = status
    @exception_type = exception_type
    super(msg)
  end
end
