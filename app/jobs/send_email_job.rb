require 'sendgrid-ruby'
require 'config'
# Description: This is a job class which is used to send email to the user.
class SendEmailJob < ApplicationJob
  include SendGrid
  queue_as :default

  SENDGRID_SUCCESS_CODE = '202'.freeze

  def perform(email_id)
    email = find_email(email_id)
    return unless email && ::Settings.sendgrid.active

    send_email(prepare_email_data(email))
  end

  private

  def find_email(email_id)
    ::Email.find_by(id: email_id)
  end

  def sendgrid_api
    @sendgrid_api ||= SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid, :api_key))
  end

  def send_email(data)
    response = sendgrid_api.client.mail._('send').post(request_body: data)
    handle_response(response)
  end

  def prepare_email_data(email)
    {
      personalizations: build_personalizations(email),
      from: {
        email: email.from_email,
        name: email.from_name
      },
      template_id: email.template_id
    }
  end

  def build_personalizations(email)
    email.to_emails.map.with_index do |recipient, index|
      {
        to: [{ email: recipient }],
        dynamic_template_data: email.substitutions[index]
      }
    end
  end

  def handle_response(response)
    response if response.status_code == SENDGRID_SUCCESS_CODE
    # TODO: Add error handling
  end
end
