module Mutations
  # Mutation to sign in a user
  class SignIn < BaseMutation
    description 'Sign in a user'

    argument :password, String, required: true, description: 'Password of the user'
    argument :username, String, required: true, description: 'Username of the user'

    field :errors, [String], null: true, description: 'Errors messages'
    field :success, Boolean, null: false, description: 'Success message'
    field :token, String, null: true, description: 'Token'
    field :user, Types::UserType, null: true, description: 'User Type'

    def resolve(args)
      result = Users::SignInService.call(args)
      {
        errors: result.errors,
        success: result.success,
        token: result.data ? "Bearer #{result.data[:token]}" : nil,
        user: result.data ? result.data[:user] : nil
      }
    end
  end
end
