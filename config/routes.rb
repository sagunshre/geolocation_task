Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/geolocations", to: "geolocations#index"
  resource :geolocation
  match '*unmatched', to: 'application#routing_error', via: :all
end
