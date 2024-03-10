module Users
  # Service object to handle sending confirmation email
  class SendConfirmationService < ApplicationService
    USER_NOT_FOUND_ERROR = I18n.t('services.users.send_confirmation.user_not_found')
    USER_ALREADY_CONFIRMED_ERROR = I18n.t('services.users.send_confirmation.user_already_confirmed')
    CONFIRMATION_SENT_MSG = I18n.t('services.users.send_confirmation.confirmation_email_sent')

    def call
      return failure(USER_NOT_FOUND_ERROR) unless user
      return failure(USER_ALREADY_CONFIRMED_ERROR) if user.confirmed?

      send_confirmation_email
      log_event(user:, data: { confirmation_sent: true })
      success(CONFIRMATION_SENT_MSG)
    end

    private

    def permitted_params
      @params.slice(:id)
    end

    def user
      @user ||= User.find_by(id: permitted_params[:id])
    end

    def failure(message)
      result.new(nil, false, [message])
    end

    def success(message)
      result.new(message, true, nil)
    end

    def send_confirmation_email
      email = Email.create_confirmation_email!(user:)
      SendEmailJob.perform_later(email.id)
    end
  end
end
