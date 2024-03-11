module Users
  # Service object to handle sending reset password email
  class SendResetPasswordService < ApplicationService
    def call
      return success_result unless user

      send_reset_password_email
      log_event(user:, data: { email: user.email })
      success_result
    end

    private

    def permitted_params
      params.slice(:auth)
    end

    def user
      @user ||= User.find_by(email: permitted_params[:auth]) || User.find_by(username: permitted_params[:auth])
    end

    def send_reset_password_email
      email = Email.create_reset_password_email!(user:)
      SendEmailJob.perform_later(email.id)
    end

    def success_result
      result.new(success: true, data: I18n.t('services.users.send_reset_password.success'))
    end
  end
end
