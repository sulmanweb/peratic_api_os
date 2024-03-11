module Mutations
  # Mutation to reset user password by token
  class ResetPassword < BaseMutation
    description 'Reset user password by token'

    argument :password, String, required: true, description: 'The new password'
    argument :password_confirmation, String, required: true, description: 'The new password confirmation'
    argument :token, String, required: true, description: 'The token sent to the user email'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Indicates if the user was successfully reset'
    field :user, Types::UserType, null: true, description: 'The user'

    def resolve(args)
      service = Users::ResetPasswordService.call(args)

      {
        errors: service.errors,
        user: service.data,
        success: service.success
      }
    end
  end
end
