module Mutations
  # Mutation to update user password by password_challenge
  class UpdatePassword < BaseMutation
    description 'Update user password by password_challenge'

    argument :password, String, required: true, description: 'The new password'
    argument :password_challenge, String, required: true, description: 'The password challenge'
    argument :password_confirmation, String, required: true, description: 'The new password confirmation'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Indicates if the user was successfully updated'
    field :user, Types::UserType, null: true, description: 'The user'

    def resolve(args)
      authenticate_user

      service = Users::UpdatePasswordService.call(args.merge(id: Current.user.id))

      {
        errors: service.errors,
        user: service.data,
        success: service.success
      }
    end
  end
end
