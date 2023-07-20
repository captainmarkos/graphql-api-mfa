module Types
  module Input
    class VerifyUserInputType < Types::BaseInputObject
      argument :otp, String, required: false
    end
  end
end
