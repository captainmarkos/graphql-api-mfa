module ApiKeyAuthenticatable
  extend ActiveSupport::Concern

  # https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic/ControllerMethods.html
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  # https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Token/ControllerMethods.html
  include ActionController::HttpAuthentication::Token::ControllerMethods
 
  attr_reader :current_api_key
  attr_reader :current_bearer

  ACCESS_DENIED = "Oh no you don't! ACCESS DENIED!".freeze

  # Use this to raise an error and automatically respond with
  # a 401 HTTP status code when API key authentication fails
  def authenticate_with_api_key!
    @current_bearer = authenticate_or_request_with_http_token &method(:authenticator)
  end
 
  # Use this for optional API key authentication
  def authenticate_with_api_key
    @current_bearer = authenticate_with_http_token &method(:authenticator)
  end
 
  private
 
  attr_writer :current_api_key
  attr_writer :current_bearer
 
  def authenticator(http_token, options)
    @current_api_key = ApiKey.find_by(token: http_token)
 
    current_api_key&.bearer
  end
end