module Users
  class ChangeUsernameService < ApplicationService
    def call
      return result.new(success: false, errors: [I18n.t('services.users.change_username.user_not_found')]) if user.nil?

      update_username
    end

    private

    def permitted_params
      @params.slice(:username, :password_challenge)
    end

    def user
      @user ||= User.find_by(id: @params[:id])
    end

    def update_username
      if user.update(username: permitted_params[:username], password_challenge: permitted_params[:password_challenge])
        result.new(data: user, success: true, errors: nil)
      else
        result.new(success: false, errors: user.errors.full_messages)
      end
    end
  end
end
