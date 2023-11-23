class GeolocationsController < ApplicationController
  before_action :set_device, only: %i[ show create destory]

  rescue_from ActionController::UnpermittedParameters do |exception|
    render json: { error: exception.message + ", only 'identifier' field is permited for this api.", status: 422}, status: :unprocessable_entity
  end

  rescue_from LookupException do |exception|
    render json: exception.message
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: { error: exception.message, status: 422 }, status: :unprocessable_entity
  end

  def index
    @devices = Device.joins(:geolocation)
    render json: @devices, include: ['geolocation'], status: :ok
  end

  def show
    if @device.present?
      @device = @device.first
      @geolocation = @device.geolocation
      render json: @device, include: ['geolocation'], status: :ok
    else
      render json: {error: "Identifier Not Found", status: 404}, status: :not_found
    end
  end

  def create
    if @device.present?
      @device = @device.first
      @geolocation = @device.geolocation
      render json: @device, include: ['geolocation'], status: :ok
    else
      lookup_service = LookupService.new
      lookup_service.lookup(device_params[:identifier])
      handler = GeolocationHandler.new(lookup_service)
      @device = handler.store(device_params[:identifier])
      render json: @device, include: ['geolocation'], status: :ok
    end
  end

  private
  def set_device
    @device = Device.where(identifier: device_params[:identifier]).or(Device.where("identifier LIKE ?", "%#{device_params["identifier"]}%"))
    if @device.empty?
      geo = Geolocation.where(ip: device_params[:identifier])
                       .or(Geolocation.where("hostname LIKE ?", "%#{device_params[:identifier]}%"))
      @device = [geo.first.device] if geo.present?
    end
  end

  def device_params
    params.permit(:identifier)
  end
end
