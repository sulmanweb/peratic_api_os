# == Schema Information
#
# Table name: emails
#
#  id            :bigint           not null, primary key
#  from_email    :string
#  from_name     :string
#  substitutions :jsonb
#  to_emails     :string           default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  template_id   :string
#
# Indexes
#
#  index_emails_on_substitutions  (substitutions) USING gin
#
class Email < ApplicationRecord
  validates :to_emails, presence: true, length: { minimum: 1 }
  validates :template_id, presence: true
  validates :from_email, presence: true
  validates :from_name, presence: true

  class << self
    def create_confirmation_email!(user:, from_email: 'no-reply@peratic.com', from_name: 'Peratic')
      create_email!(
        user:,
        from_email:,
        from_name:,
        action: :email_confirmation,
        url: Settings.emails.confirm_url,
        template_id: Rails.application.credentials.dig(:sendgrid, :confirm_template_id)
      )
    end

    def create_reset_password_email!(user:, from_email: 'no-reply@peratic.com', from_name: 'Peratic')
      create_email!(
        user:,
        from_email:,
        from_name:,
        action: :password_reset,
        url: Settings.emails.reset_url,
        template_id: Rails.application.credentials.dig(:sendgrid, :reset_template_id)
      )
    end

    private

    def create_email!(user:, from_email:, from_name:, action:, url:, template_id:) # rubocop:disable Metrics/ParameterLists
      token = user.generate_token_for(action)
      Email.create!(
        to_emails: [user.email],
        from_email:,
        from_name:,
        substitutions: [{ "#{action}_url": "#{url}?token=#{token}", name: user.name }],
        template_id:
      )
    end
  end
end
