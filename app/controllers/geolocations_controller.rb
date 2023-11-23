class GeolocationsController < ApplicationController
  before_action :set_device, only: %i[ show create destory]

  rescue_from ActionController::UnpermittedParameters do |exception|
    render json: { error: exception.message + ", only 'ip' field is permited for this api.", status: 422}, status: :unprocessable_entity
  end

  rescue_from IpstackException do |exception|
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
      render json: {error: "IP Not Found", status: 404}, status: :not_found
    end
  end

  def create
    if @device.present?
      @device = @device.first
      @geolocation = @device.geolocation
      render json: @device, include: ['geolocation'], status: :ok
    else
      ipstack = Ipstack.new
      ipstack.lookup(device_params[:ip])
      handler = GeolocationHandler.new(ipstack)
      @device = handler.store
      render json: @device, include: ['geolocation'], status: :ok
    end
  end

  private
  def set_device
    @device = Device.where(ip: device_params[:ip]).or(Device.where("url LIKE ? ", "%#{device_params[:ip]}%"))
  end

  def device_params
    params.permit(:ip)
  end
end
