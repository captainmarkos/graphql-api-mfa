module Mutations
  class UserRequestOtp < Mutations::BaseMutation
    argument :params, Types::Input::UserAuthInputType, required: true

    field :otp, String, null: true

    def resolve(params:)
      mutation_params = Hash params
      user = context[:current_bearer]

      return { otp: nil } unless valid_conditions?(user, mutation_params)

      user.one_time_passwords.create

      { otp: user.one_time_passwords.newest.otp }
    rescue StandardError => e
      graphql_execution_error(e)
    end

    private

    def valid_conditions?(user, mutation_params)
      # We need to make sure user.email is the same as the email in params.
      user.present? && 
        mutation_params[:email].present? && 
        user.email == mutation_params[:email]
    end
  end
end
