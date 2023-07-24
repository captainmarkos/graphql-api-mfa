module Types
  module Input
    class CreateUserInputType < Types::BaseInputObject
      argument :email, String, required: true
      argument :password, String, required: true
    end
  end
end
