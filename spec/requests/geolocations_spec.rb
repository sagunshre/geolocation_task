require 'rails_helper'
require 'faker'

RSpec.describe "Geolocations", type: :request do
  describe "GET index" do
    let!(:ip1) { Faker::Internet.ip_v4_address }
    let!(:device1) { FactoryBot.create(:device1, identifier: ip1) }
    let!(:geolocation1) {FactoryBot.create(:geolocation1, ip: ip1, device: device1)}

    let!(:ip2) { Faker::Internet.ip_v4_address }
    let!(:device2) { FactoryBot.create(:device1, identifier: ip2) }
    let!(:geolocation2) {FactoryBot.create(:geolocation1, ip: ip2, device: device2)}

    before do
      get "/geolocations"
    end

    it "Returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "Expect response body to be Array of geolocations" do
      expect(response).to match_response_schema("geolocations")
    end
  end

  describe "GET show" do
    describe "SUCCESS" do
      let!(:ip1) { Faker::Internet.ip_v4_address }
      let!(:device1) { FactoryBot.create(:device1, identifier: ip1) }
      let!(:geolocation1) {FactoryBot.create(:geolocation1, ip: ip1, device: device1)}

      let!(:ip2) { Faker::Internet.ip_v4_address }
      let!(:device2) { FactoryBot.create(:device1, identifier: ip2) }
      let!(:geolocation2) {FactoryBot.create(:geolocation1, ip: ip2, device: device2)}

      before do
        get "/geolocation", params: {"identifier": ip1}
      end

      it "Returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "Return geolocation of device identifier in request query params" do
        resp = JSON.parse(response.body)
        expect(resp["data"]["attributes"]["device_identifier"]).to eql(ip1)
        expect(response).to match_response_schema("geolocation")
      end
    end

    it "Returns Unprocessable Entity" do
      get "/geolocation", params: {"identifier": nil}
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "Returns Record Not Found" do
      get "/geolocation", params: {"identifier": Faker::Internet.ip_v4_address}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    let!(:ip1) { Faker::Internet.ip_v4_address }
    let!(:ip2) { Faker::Internet.ip_v4_address }

    describe "SUCCESS" do
      before do
        content = File.read("spec/support/response/ipstack_response1.json")
        response = JSON.parse(content)
        response["ip"] = ip1
        url = ENV["BASE_URL"]
        url += ip1
        url += "?access_key=" + ENV["ACCESS_KEY"]
        url += "&language=en"
        url += "&hostname=1"
        stub_request(:get, url).to_return_json(body: response)
      end

      it "Returns http success" do
        post "/geolocation", params: {"identifier": ip1}
        expect(response).to have_http_status(:success)
      end

      it "Looked up for Geolocation using ipstack" do
        expect{
          post "/geolocation", params: {"identifier": ip1}
        }.to change(Geolocation, :count).by(1)
      end
    end

    it "Returns Unprocessable Entity" do
      post "/geolocation", params: {"identifier": ""}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
