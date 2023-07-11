module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # describe field signatures
    field :api_user, ApiUserType, 'Find api user by id' do
      argument :id, ID
    end

    field :api_users, [Types::ApiUserType], null: false, description: 'Return a list of api users'

    # provide implementations
    def api_user(id:)
      User.includes(:api_keys).find_by(id: id)
    end

    def api_users
      User.includes(:api_keys).all
    end
  end
end
