# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authenticate_user
      Current.user || raise(GraphQL::ExecutionError, I18n.t('gql.unauthenticated'))
    end
  end
end
