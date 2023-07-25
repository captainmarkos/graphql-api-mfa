module Mutations
  class UserCreate < Mutations::BaseMutation
    argument :params, Types::Input::CreateUserInputType, required: true

    field :user, Types::ApiUserType, null: true

    # For now this query requires a user with an api key 
    # to make this request then a new user can be created.
    def resolve(params:)
      mutation_params = Hash params
      sys_msg = []
      user = User.includes(:api_keys).find_by(email: mutation_params[:email])

      if user.present?
        sys_msg << 'user already existed'
        sys_msg << 'api key created' if create_api_key(user, mutation_params)
      else
        new_user = User.create(
          email: mutation_params[:email],
          password: mutation_params[:password]
        )

        sys_msg << 'user created'
        sys_msg << 'api key created' if create_api_key(new_user, mutation_params)
      end

      { user: hashified(user: user, sys_msg: sys_msg) }
    rescue StandardError => e
      graphql_execution_error(e)
    end

    private

    def hashified(user:, sys_msg: [])
      user.as_json.merge({
        active_token: user.api_keys.newest.try(:token),
        api_keys: user.api_keys.newest.as_json,
        system_message: sys_msg.compact.join(',')
      })
    end

    def create_api_key(user, mutation_params)
      # create an api key for the user if allowed
      if mutation_params[:create_api_key].present? && user.api_keys.blank?
        user.api_keys.new.save
      end
    end
  end
end
