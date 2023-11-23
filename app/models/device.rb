require "resolv"

class Device < ApplicationRecord
  validates :ip, :presence => true, :uniqueness => true, :format => { :with => Resolv::AddressRegex }
  has_one :geolocation
end
