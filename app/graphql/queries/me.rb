module Queries
  # Fetches the current user
  class Me < Queries::BaseQuery
    description 'Fetches the current user'

    type Types::UserType, null: true

    def resolve
      authenticate_user
      Current.user
    end
  end
end
