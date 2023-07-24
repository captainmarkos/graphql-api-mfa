module Types
  module Input
    class VerifyUserOtpInputType < Types::BaseInputObject
      argument :otp, String, required: true
    end
  end
end
