module Mutations
  # Mutation to destroy the user
  class SelfDestroy < BaseMutation
    description 'Destroy the user'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Success message'

    def resolve
      authenticate_user

      result = Users::DestroyService.call({ id: Current.user.id })
      {
        errors: result.errors,
        success: result.success
      }
    end
  end
end
