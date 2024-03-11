require 'rails_helper'

RSpec.describe Users::ResetPasswordService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) do
    { token: user.generate_token_for(:password_reset), password: 'Abcd@1234', password_confirmation: 'Abcd@1234' }
  end

  describe '#call' do
    context 'when the token is valid' do
      it 'resets the user password' do
        expect { service }.to(change { user.reload.password_digest })
      end

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end
    end

    context 'when the token is invalid' do
      let(:params) { { token: 'invalid', password: 'Abcd@1234', password_confirmation: 'Abcd@1234' } }

      it 'does not reset the user password' do
        expect { service }.not_to(change { user.reload.password_digest })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the password and password confirmation do not match' do
      let(:params) do
        { token: user.generate_token_for(:password_reset), password: 'Abcd@1234', password_confirmation: 'Abcd@12345' }
      end

      it 'does not reset the user password' do
        expect { service }.not_to(change { user.reload.password_digest })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the password is invalid' do
      let(:params) do
        { token: user.generate_token_for(:password_reset), password: 'abcd1234', password_confirmation: 'abcd1234' }
      end

      it 'does not reset the user password' do
        expect { service }.not_to(change { user.reload.password_digest })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
