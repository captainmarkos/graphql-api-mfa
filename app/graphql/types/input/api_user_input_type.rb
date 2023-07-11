module Types
  module Input
    class ApiUserInputType < Types::BaseInputObject
      argument :email, String, required: true
    end
  end
end
