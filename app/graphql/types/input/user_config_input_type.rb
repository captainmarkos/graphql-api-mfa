module Types
  module Input
    class UserConfigInputType < Types::BaseInputObject
      argument :email, String, required: true
      argument :otp_enabled, Boolean, required: false
    end
  end
end
