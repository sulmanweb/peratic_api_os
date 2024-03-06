require 'rails_helper'

RSpec.describe Users::SignUpService do
  subject(:service) { described_class.call(params) }

  let(:params) { attributes_for(:user) }

  describe '#call' do
    context 'when the user is valid' do
      it 'creates a new user' do
        expect { service }.to change(User, :count).by(1)
      end

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end

      it 'have enqueued a job' do
        expect { service }.to have_enqueued_job(SendEmailJob)
      end

      it 'creates an audit log' do
        expect { service }.to change(AuditLog, :count).by(1)
      end
    end

    context 'when the user is invalid' do
      let(:params) { attributes_for(:user, email: nil) }

      it 'does not create a new user' do
        expect { service }.not_to change(User, :count)
      end

      it 'returns an error result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
