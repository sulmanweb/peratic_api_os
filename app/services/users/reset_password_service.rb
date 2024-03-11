module Users
  # Service object to handle user password reset by token
  class ResetPasswordService < ApplicationService
    def call
      return result.new(success: false, errors: [I18n.t('services.users.reset_password.token_failed')]) if user.nil?

      update_password
    end

    private

    def permitted_params
      @params.slice(:token, :password, :password_confirmation)
    end

    def user
      @user ||= User.find_by_token_for(:password_reset, permitted_params[:token])
    end

    def update_password
      if user.update(password: permitted_params[:password], password_confirmation: permitted_params[:password_confirmation])
        result.new(data: user, success: true, errors: nil)
      else
        result.new(success: false, errors: user.errors.full_messages)
      end
    end
  end
end
