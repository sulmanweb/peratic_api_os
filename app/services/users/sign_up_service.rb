module Users
  # Service object to handle user sign up
  class SignUpService < ApplicationService
    def call
      return result.new(data: nil, success: false, errors: user.errors.full_messages) unless user.valid?

      user.save!
      post_sign_up_actions

      result.new(data: user, success: true, errors: nil)
    end

    private

    def permitted_params
      @params.slice(:email, :name, :password, :username)
    end

    def build_user
      User.new(permitted_params)
    end

    def user
      @user ||= build_user
    end

    def post_sign_up_actions
      email = Email.create_confirmation_email!(user:)
      SendEmailJob.perform_later(email.id)
    end
  end
end
