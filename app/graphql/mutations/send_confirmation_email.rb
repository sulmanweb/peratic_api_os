module Mutations
  # Mutation to send confirmation email
  class SendConfirmationEmail < BaseMutation
    description 'Send confirmation email'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Success message'

    def resolve
      authenticate_user

      result = Users::SendConfirmationService.call({ id: Current.user.id })
      {
        errors: result.errors,
        success: result.success
      }
    end
  end
end
