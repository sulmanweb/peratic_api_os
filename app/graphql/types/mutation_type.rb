# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in a user'
    field :sign_up, mutation: Mutations::SignUp, description: 'Sign up a new user'
  end
end
