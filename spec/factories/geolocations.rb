require 'faker'

FactoryBot.define do
  factory :geolocation1, class: Geolocation do
     continent {Faker::Address.time_zone}
     country {Faker::Address.country}
     region {Faker::Address.state}
     city {Faker::Address.city}
     latitude {Faker::Address.latitude}
     longitude {Faker::Address.longitude}
     zip {Faker::Address.zip_code}
     ip {Faker::Internet.ip_v4_address}
     hostname {Faker::Internet.domain_name}
  end
end