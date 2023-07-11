module Types
  class ApiUserType < Types::BaseObject
    description 'API User'
    field :id, ID, null: false
    field :email, String, null: false
    field :password_digest, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :api_keys, [Types::ApiKeyType]
  end
end
