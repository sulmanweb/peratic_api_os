module Mutations
  # Mutation to send reset password email
  class SendResetPassword < BaseMutation
    description 'Send reset password email'

    argument :auth, String, required: true, description: 'User email or username'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Success message'

    def resolve(args)
      result = Users::SendResetPasswordService.call(args)
      {
        errors: result.errors,
        success: result.success
      }
    end
  end
end
