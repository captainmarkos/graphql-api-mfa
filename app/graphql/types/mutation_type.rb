module Types
  class MutationType < Types::BaseObject
    field :user_create, mutation: Mutations::UserCreate
    field :user_request_otp, mutation: Mutations::UserRequestOtp
    field :user_verify_otp, mutation: Mutations::UserVerifyOtp

    field :user_config_admin, mutation: Mutations::UserConfigAdmin
    #field :verify_user, mutation: Mutations::VerifyUser
    field :revoke_api_key, mutation: Mutations::RevokeApiKey
  end
end
