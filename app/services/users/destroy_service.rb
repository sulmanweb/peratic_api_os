module Users
  # Service object to handle user deletion
  class DestroyService < ApplicationService
    def call
      return user_not_found_result if user.blank?

      destroy_user_and_log_event
      success_result
    end

    private

    def permitted_params
      @params.slice(:id)
    end

    def user
      @user ||= User.find_by(id: permitted_params[:id])
    end

    def user_not_found_result
      result.new(nil, false, [I18n.t('services.users.destroy.user_not_found')])
    end

    def destroy_user_and_log_event
      user.destroy!
      log_event(user:, data: { id: user.id })
    end

    def success_result
      result.new(user, true, nil)
    end
  end
end
