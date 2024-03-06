module Queries
  # Base query from which all queries inherit
  class BaseQuery < GraphQL::Schema::Resolver
    description 'Base query from which all queries inherit'

    def authenticate_user
      Current.user || raise(GraphQL::ExecutionError, I18n.t('gql.unauthenticated'))
    end
  end
end
