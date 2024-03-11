require 'rails_helper'

RSpec.describe Users::ConfirmService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) { { token: user.generate_token_for(:email_confirmation) } }

  describe '#call' do
    context 'when the token is valid' do
      it 'confirms the user' do
        expect { service }.to change { user.reload.email_confirmed_at }.from(nil)
      end

      it 'logs the event' do
        expect { service }.to change(AuditLog, :count).by(1)
      end

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end
    end

    context 'when the token is invalid' do
      let(:params) { { token: 'invalid' } }

      it 'does not confirm the user' do
        expect { service }.not_to(change { user.reload.email_confirmed_at })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when token generated is for other type' do
      let(:params) { { token: user.generate_token_for(:password_reset) } }

      it 'does not confirm the user' do
        expect { service }.not_to(change { user.reload.email_confirmed_at })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
