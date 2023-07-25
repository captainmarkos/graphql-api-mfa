module Types
  class ApiUserType < Types::BaseObject
    description 'API User'
    field :id, ID, null: false
    field :email, String, null: false
    field :password_digest, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :api_keys, [Types::ApiKeyType], null: true
    field :active_token, String, null: true, resolver_method: :fetch_active_token
    field :system_message, String, null: false

    def fetch_active_token
      if object.is_a?(User)
        object.api_keys.newest.try(:token)
      elsif object.is_a?(Hash)
        object[:active_token]
      end
    end
  end
end
