module Types
  class MutationType < Types::BaseObject
    field :user_config_admin, mutation: Mutations::UserConfigAdmin
    field :verify_user, mutation: Mutations::VerifyUser
    field :revoke_api_key, mutation: Mutations::RevokeApiKey
  end
end
