module Mutations
  class UserConfigAdmin < Mutations::BaseMutation
    argument :params, Types::Input::UserConfigInputType, required: true

    field :attributes, Types::UserConfigType, null: true

    def resolve(params:)
      mutation_params = Hash params
      user = User.includes(:config).find_by(email: mutation_params[:email])

      if user.present?
        otp_enabled = mutation_params.fetch(:otp_enabled, user.config.otp_enabled)
        user.config.update!(otp_enabled: otp_enabled)
      end

      { attributes: user.present? ? user.config : nil }
    rescue StandardError => e
      graphql_execution_error(e)
    end
  end
end
