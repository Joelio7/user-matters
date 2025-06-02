class Api::ApplicationController < ActionController::API
  include ExceptionHandler
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  private

  def handle_not_authorized(exception)
    render json: ErrorSerializer.new(
      message: "Access denied",
      errors: [ exception.message ]
    ).as_json, status: :forbidden
  end
end
