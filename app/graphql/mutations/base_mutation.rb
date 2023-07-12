module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def graphql_execution_error(e)
      message = error_message(e)
      Rails.logger.error(message)
      GraphQL::ExecutionError.new(message)
    end

    def error_message(exception)
      if (record = exception.try(:record)).present?
        # message for ActiveRecord::RecordInvalid exceptions
        "Invalid attributes for #{record.class}: #{exception}"
      else
        exception.to_s
      end
    end
  end
end
