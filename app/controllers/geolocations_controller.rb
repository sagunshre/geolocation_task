class GeolocationsController < ApplicationController
  before_action :return_if_identifier_blank, only: %i[ show create destroy]
  before_action :set_device, only: %i[ show create destroy]

  rescue_from ActionController::UnpermittedParameters do |exception|
    render json: { error: exception.message + ", only 'identifier' field is permited for this api.", status: 422}, status: :unprocessable_entity
  end

  rescue_from LookupException do |exception|
    render json: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: "Geolocation not found", status: 404 }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: { error: exception.message, status: 422 }, status: :unprocessable_entity
  end

  def index
    @geolocations = Geolocation.all
    resp = GeolocationSerializer.new(@geolocations).serialized_json
    render json: resp, status: :ok
  end

  def show
    if @device.present?
      @device = @device.first
      @geolocation = @device.geolocation
      resp = GeolocationSerializer.new(@geolocation).serialized_json
      render json: resp, status: :ok
    else
      render json: {error: "Identifier Not Found", status: 404}, status: :not_found
    end
  end

  def create
    if @device.present?
      @geolocation = @device.first.try(:geolocation)
    else
      lookup_service = LookupService.new
      lookup_service.lookup(device_params[:identifier])
      handler = GeolocationHandler.new(lookup_service)
      @geolocation = handler.store(device_params[:identifier])
    end
    resp = GeolocationSerializer.new(@geolocation).serialized_json
    render json: resp, status: :ok
  end

  def destroy
    if @device.present?
      @device.destroy_all
      render json: {message: "#{device_params["identifier"]} has been deleted.", status: 200}, status: :ok
    else
      render json: {error: "Identifier Not Found", status: 404}, status: :not_found
    end
  end

  private
  def return_if_identifier_blank
    if device_params["identifier"].blank?
      render json: {error: "Identifier cannot be empty", status: 422}, status: :unprocessable_entity
    end
  end

  def set_device
    @device = Device.where(identifier: device_params[:identifier]).or(Device.where("identifier LIKE ?", "%#{device_params["identifier"]}%"))
    if @device.empty?
      geo = Geolocation.where(ip: device_params[:identifier])
                       .or(Geolocation.where("hostname LIKE ?", "%#{device_params[:identifier]}%"))
      @device = Device.where(id: geo.first.device_id) if geo.present?
    end
  end

  def device_params
    params.permit(:identifier)
  end
end
