require 'rails_helper'

RSpec.describe SendEmailJob, type: :job do
  it 'sends an email' do
    email = create(:email)
    expect { described_class.perform_later(email.id) }.to have_enqueued_job(described_class)
  end
end
