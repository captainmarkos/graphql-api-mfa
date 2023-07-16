module Mutations
  class VerifyUser < Mutations::BaseMutation
    argument :params, Types::Input::ApiUserInputType, required: true

    field :authenticate, Types::ApiUserType, null: true

    # TODO: this should be a query and not a mutation
    def resolve(params:)
      mutation_params = Hash params
      user = User.includes(:config).find_by(email: mutation_params[:email])

      if user.present?
        result = if user.otp_enabled?
          # verify user with one time password
          user.authenticate_with_otp(otp: mutation_params[:otp])        
        else
          # verify user with password
          user.authenticate(mutation_params[:password])
        end

        { authenticate: result.present? ? result.as_json : nil }
      end
    rescue StandardError => e
      graphql_execution_error(e)
    end
  end
end
