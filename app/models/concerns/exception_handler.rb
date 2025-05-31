module ExceptionHandler
  extend ActiveSupport::Concern
  
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  
  included do
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
  end
  
  private
  
  def unauthorized_request(e)
    render json: ErrorSerializer.new(message: e.message).as_json, status: :unauthorized
  end
end