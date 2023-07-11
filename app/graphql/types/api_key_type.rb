module Types
  class ApiKeyType < Types::BaseObject
    description 'API Key'
    field :id, ID, null: false
    field :bearer, Types::ApiUserType, null: false
    field :token, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :status, String, null: true
  end
end
