module Users
  # Service object to handle user sign in
  class SignInService < ApplicationService
    def call
      return result.new(data: nil, success: false, errors: [I18n.t('services.users.sign_in.auth_failure')]) unless user

      token = user.generate_token_for(:auth_token)

      log_event(user:, data: { username: user.username })
      result.new(data: { user:, token: }, success: true, errors: nil)
    end

    private

    def permitted_params
      @params.slice(:username, :password)
    end

    def user
      @user ||= User.authenticate_by(permitted_params)
    end
  end
end
