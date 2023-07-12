module Mutations
  class RevokeApiKey < Mutations::BaseMutation
    argument :params, Types::Input::ApiUserInputType, required: true

    field :api_key, Types::ApiKeyType, null: true

    def resolve(params:)
      mutation_params = Hash params
      user = User.find_by(email: mutation_params[:email])

      if user.present? && (newest_key = user.api_keys.newest).present?
        deleted_api_key = newest_key.destroy.as_json.merge(status: 'revoked', bearer: user)

        { api_key: deleted_api_key }
      end
    rescue ActiveRecord::RecordInvalid => e
      graphql_execution_error(e)
    end
  end
end
