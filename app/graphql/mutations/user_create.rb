module Mutations
  class UserCreate < Mutations::BaseMutation
    argument :params, Types::Input::CreateUserInputType, required: true

    field :user, Types::ApiUserType, null: true

    # For now this query requires a user with an api key 
    # to make this request then a new user can be created.
    def resolve(params:)
      mutation_params = Hash params

      user = User.find_by(email: mutation_params[:email])

      if user.present?
        { user: user.as_json.merge(system_message: 'user already existed') }
      else
        new_user = User.create(
          email: mutation_params[:email],
          password: mutation_params[:password]
        )

        { user: new_user.as_json.merge(system_message: 'user created') }
      end
    rescue StandardError => e
      graphql_execution_error(e)
    end
  end
end
