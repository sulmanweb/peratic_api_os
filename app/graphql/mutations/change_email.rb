module Mutations
  # Mutation to change user email by password_challenge
  class ChangeEmail < BaseMutation
    description 'Change user email by password_challenge'

    argument :email, String, required: true, description: 'The new email'
    argument :password_challenge, String, required: true, description: 'The password challenge'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Indicates if the user was successfully updated'
    field :user, Types::UserType, null: true, description: 'The user'

    def resolve(args)
      authenticate_user

      service = Users::ChangeEmailService.call(args.merge(id: Current.user.id))

      {
        errors: service.errors,
        user: service.data,
        success: service.success
      }
    end
  end
end
