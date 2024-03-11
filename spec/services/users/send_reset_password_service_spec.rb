require 'rails_helper'

RSpec.describe Users::SendResetPasswordService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) { { auth: user.email } }

  describe '#call' do
    context 'when user is found by email' do
      it 'sends reset password email' do
        expect { service }.to have_enqueued_job(SendEmailJob)
      end

      it 'logs event' do
        expect { service }.to change(Email, :count).by(1)
      end

      it 'returns success' do
        expect(service.success).to be_truthy
      end
    end

    context 'when user is found by username' do
      let(:params) { { auth: user.username } }

      it 'sends reset password email' do
        expect { service }.to have_enqueued_job(SendEmailJob)
      end

      it 'logs event' do
        expect { service }.to change(Email, :count).by(1)
      end

      it 'returns success' do
        expect(service.success).to be_truthy
      end
    end

    context 'when user is not found' do
      let(:params) { { auth: 'invalid' } }

      it 'returns success' do
        expect(service.success).to be_truthy
      end
    end
  end
end
