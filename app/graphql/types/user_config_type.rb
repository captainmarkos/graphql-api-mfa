module Types
  class UserConfigType < Types::BaseObject
    description 'User Config'
    field :user, Types::ApiUserType, null: false
    field :otp_enabled, Boolean, null: false
  end
end
