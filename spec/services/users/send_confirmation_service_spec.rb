require 'rails_helper'

RSpec.describe Users::SendConfirmationService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) { { id: user.id } }

  describe '#call' do
    context 'when user is found' do
      it 'sends confirmation email' do
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
      let(:params) { { id: 0 } }

      it 'returns failure' do
        expect(service.success).to be_falsey
      end
    end

    context 'when user is already confirmed' do
      let(:user) { create(:user, :confirmed) }

      it 'returns failure' do
        expect(service.success).to be_falsey
      end
    end
  end
end
