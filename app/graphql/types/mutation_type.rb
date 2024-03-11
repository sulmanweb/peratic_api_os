# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :confirm_email, mutation: Mutations::ConfirmEmail, description: 'Confirm the email of a user'
    field :self_destroy, mutation: Mutations::SelfDestroy, description: 'Destroy the user'
    field :send_confirmation_email, mutation: Mutations::SendConfirmationEmail, description: 'Send confirmation email'
    field :send_reset_password, mutation: Mutations::SendResetPassword, description: 'Send reset password email'
    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in a user'
    field :sign_up, mutation: Mutations::SignUp, description: 'Sign up a new user'
  end
end
