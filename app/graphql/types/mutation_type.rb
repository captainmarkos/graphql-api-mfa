module Types
  class MutationType < Types::BaseObject
    field :revoke_api_key, mutation: Mutations::RevokeApiKey
  end
end
