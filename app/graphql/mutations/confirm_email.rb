module Mutations
  # Mutation to confirm the email of a user
  class ConfirmEmail < BaseMutation
    description 'Confirm the email of a user'

    argument :token, String, required: true, description: 'Token to confirm the email'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Success message'
    field :user, Types::UserType, null: true, description: 'User Type'

    def resolve(args)
      result = Users::ConfirmService.call(args)

      {
        errors: result.errors,
        success: result.success,
        user: result.data
      }
    end
  end
end
