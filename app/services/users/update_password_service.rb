module Users
  # Service object to handle user password update given password_challenge
  class UpdatePasswordService < ApplicationService
    def call
      return result.new(success: false, errors: [I18n.t('services.users.update_password.user_not_found')]) if user.nil?

      update_password
    end

    private

    def permitted_params
      @params.slice(:password_challenge, :password, :password_confirmation)
    end

    def user
      @user ||= User.find_by(id: @params[:id])
    end

    def update_password
      if user.update(password: permitted_params[:password],
                     password_confirmation: permitted_params[:password_confirmation],
                     password_challenge: permitted_params[:password_challenge])
        result.new(data: user, success: true, errors: nil)
      else
        result.new(success: false, errors: user.errors.full_messages)
      end
    end
  end
end
