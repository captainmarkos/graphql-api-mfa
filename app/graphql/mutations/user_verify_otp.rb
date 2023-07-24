module Mutations
  class UserVerifyOtp < Mutations::BaseMutation
    argument :params, Types::Input::UserAuthInputType, required: true

    field :verified, Types::ApiUserType, null: true

    # This mutation is only executed if authenticated by Basic Auth
    # in the GraphqlController.  If the user is authenticated and
    # has no api key then one is created.
    def resolve(params:)
      mutation_params = Hash params
      user = context[:current_bearer]

      result = if user.present? && user.otp_enabled?
        user.authenticate_with_otp(otp: mutation_params[:otp])
      end

      { verified: result.present? ? result.as_json : nil }
    rescue StandardError => e
      graphql_execution_error(e)
    end
  end
end
