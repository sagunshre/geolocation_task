class ApplicationController < ActionController::API
  def routing_error
    render json: { error: "API does not exist", status: 404 }, status: :not_found
  end
end
