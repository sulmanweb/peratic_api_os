module Users
  # Service object to handle user email change given password_challenge
  class ChangeEmailService < ApplicationService
    def call
      return result.new(success: false, errors: [I18n.t('services.users.change_email.user_not_found')]) if user.nil?

      unless user.email != permitted_params[:email]
        return result.new(success: false,
                          errors: [I18n.t('services.users.change_email.no_new_email')])
      end

      update_email
    end

    private

    def permitted_params
      @params.slice(:email, :password_challenge)
    end

    def user
      @user ||= User.find_by(id: @params[:id])
    end

    def update_email
      if user.update(email: permitted_params[:email], password_challenge: permitted_params[:password_challenge],
                     email_confirmed_at: nil)
        email = Email.create_confirmation_email!(user:)
        SendEmailJob.perform_later(email.id)
        result.new(data: user, success: true, errors: nil)
      else
        result.new(success: false, errors: user.errors.full_messages)
      end
    end
  end
end
