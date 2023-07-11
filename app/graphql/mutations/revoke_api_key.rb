module Mutations
  class RevokeApiKey < Mutations::BaseMutation
    argument :params, Types::Input::ApiUserInputType, required: true

    field :api_key, Types::ApiKeyType, null: true

    def resolve(params:)
      api_user_params = Hash params

      if (user = User.find_by(email: api_user_params[:email])).present?
        if (newest_key = user.api_keys.newest).present?
          deleted_api_key = newest_key.destroy.as_json.merge(status: 'revoked')

          { api_key: deleted_api_key }
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
