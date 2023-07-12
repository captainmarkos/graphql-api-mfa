module Mutations
  class VerifyUser < Mutations::BaseMutation
    argument :params, Types::Input::ApiUserInputType, required: true

    field :authenticate, Types::ApiUserType, null: true

    def resolve(params:)
      mutation_params = Hash params
      user = User.find_by(email: mutation_params[:email])

      if user.present?
        result = if user.otp_enabled?
          # verify user with one time password
          user.authenticate_with_otp(otp: mutation_params[:otp])        
        else
          # verify user with password
          user.authenticate(mutation_params[:password])
        end

        reset_one_time_password(user) if result.present?

        { authenticate: result.present? ? result.as_json : nil }
      end
    rescue StandardError => e
      graphql_execution_error(e)
    end

    private

    def reset_one_time_password(user)
      return unless user.otp_enabled?

      user.one_time_passwords.enabled.update_all(enabled: false)

      OneTimePassword.create!(user: user, enabled: true)
    end
  end
end
