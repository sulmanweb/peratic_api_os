module Users
  # Service object to handle user email confirmation by token
  class ConfirmService < ApplicationService
    def call
      return result.new(success: false, errors: [I18n.t('services.users.confirm.token_failed')]) if user.nil?

      user.confirm!
      log_event(user:, data: { email: user.email })
      result.new(data: user, success: true, errors: nil)
    end

    private

    def permitted_params
      @params.slice(:token)
    end

    def user
      @user ||= User.find_by_token_for(:email_confirmation, permitted_params[:token])
    end
  end
end
