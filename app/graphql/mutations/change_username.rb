module Mutations
  # Mutation to change user username by password_challenge
  class ChangeUsername < BaseMutation
    description 'Change user username by password_challenge'

    argument :password_challenge, String, required: true, description: 'The password challenge'
    argument :username, String, required: true, description: 'The new username'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Indicates if the user was successfully updated'
    field :user, Types::UserType, null: true, description: 'The user'

    def resolve(args)
      authenticate_user

      service = Users::ChangeUsernameService.call(args.merge(id: Current.user.id))

      {
        errors: service.errors,
        user: service.data,
        success: service.success
      }
    end
  end
end
