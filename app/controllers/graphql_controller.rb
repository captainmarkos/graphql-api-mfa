class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  include ApiAuthenticator

  prepend_before_action :authenticate_for_query, only: [:execute]

  def execute
    return render json: { error: ACCESS_DENIED }, status: 401 unless current_bearer

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    result = GraphqlApiMfaSchema.execute(
      query,
      variables: variables,
      context: query_context,
      operation_name: operation_name
    )

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def query_context
    {
      current_bearer: current_bearer
    }
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def api_key_required?
    # If we find that other queries do not require an api key then
    # perhaps consider a different way.  For now this works.
    !params[:query].match?(/\s*mutation.+\s*verifyUser/) &&
    !params[:query].match?(/\s*query\s+IntrospectionQuery/)
  end

  def authenticate_for_query
    if api_key_required?
      authenticate_with_api_key
    else
      authenticate_with_basic_auth
      authenticate_with_api_key if current_bearer.blank?
    end
  end
end
