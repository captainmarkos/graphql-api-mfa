module Types
  module Input
    class CreateUserInputType < Types::BaseInputObject
      argument :email, String, required: true
      argument :password, String, required: true
      argument :create_api_key, Boolean, required: false
    end
  end
end
