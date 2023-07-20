module ApiAuthenticator
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
 
  def authenticate_with_api_key
    @current_bearer = authenticate_with_http_token &method(:token_authenticator)
  end
 
  def authenticate_with_basic_auth
    @current_bearer = authenticate_with_http_basic &method(:basic_authenticator)
  end

  private
 
  attr_writer :current_api_key
  attr_writer :current_bearer
 
  def token_authenticator(http_token, options)
    @current_api_key = ApiKey.find_by(token: http_token)
 
    current_api_key&.bearer
  end

  def basic_authenticator(email, password)
    user = User.find_by(email: email)

    return if user.blank? || !user.authenticate(password)

    if (@current_api_key = user.api_keys.newest).blank?
      @current_api_key = user.api_keys.create!
    end

    current_api_key&.bearer
  end
end
