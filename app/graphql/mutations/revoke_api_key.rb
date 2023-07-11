# Mutations::RevokeApiKey
module Mutations
  class RevokeApiKey < Mutations::BaseMutation
    #argument :params, Types::Input::NoteInputType, required: true
    argument :params, Types::Input::ApiUserInputType, required: true

    field :api_key, Types::ApiKeyType, null: true

    def resolve(params:)
      api_user_params = Hash params

      if (user = User.find_by(email: api_user_params[:email])).present?
        # delete the newest api key
        deleted_api_key = user.api_keys.newest.destroy
        { api_key: deleted_api_key.as_json.merge(status: 'revoked') }
      end
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
