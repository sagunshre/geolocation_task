class Device < ApplicationRecord
  validates :identifier, :presence => true, :uniqueness => true
  has_one :geolocation
end
