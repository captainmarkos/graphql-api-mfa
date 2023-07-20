module Types
  module Input
    class UserAuthInputType < Types::BaseInputObject
      argument :otp, String, required: false
    end
  end
end
