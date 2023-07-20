module Types
  module Input
    class ApiUserInputType < Types::BaseInputObject
      argument :email, String, required: true
      argument :password, String, required: false
    end
  end
end
