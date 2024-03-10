module Users
  # Service object to handle user deletion for solf deleted users
  class DestroyFullyService < ApplicationService
    def call
      return user_not_found_result if user.blank?

      destroy_user
      success_result
    end

    private

    def permitted_params
      @params.slice(:id)
    end

    def user
      @user ||= User.only_deleted.find_by(id: permitted_params[:id])
    end

    def user_not_found_result
      result.new(nil, false, [I18n.t('services.users.destroy_fully.user_not_found')])
    end

    def destroy_user
      user.destroy_fully!
    end

    def success_result
      result.new(nil, true, nil)
    end
  end
end
