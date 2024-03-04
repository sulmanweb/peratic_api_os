module Mutations
  # Mutation to sign up a new user
  class SignUp < BaseMutation
    description 'Sign up a new user'

    argument :email, String, required: true, description: 'Email of the user'
    argument :name, String, required: true, description: 'Name of the user'
    argument :password, String, required: true, description: 'Password of the user'
    argument :username, String, required: true, description: 'Username of the user'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: true, description: 'Success message'
    field :user, Types::UserType, null: true, description: 'User Type'

    def resolve(args)
      result = Users::SignUpService.call(args)
      {
        errors: result.errors,
        success: result.success,
        user: result.data
      }
    end
  end
end
