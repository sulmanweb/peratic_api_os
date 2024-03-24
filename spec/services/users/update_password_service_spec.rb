require 'rails_helper'

RSpec.describe Users::UpdatePasswordService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) do
    { id: user.id, password_challenge: 'Abcd@1234', password: 'Amal@1234', password_confirmation: 'Amal@1234' }
  end

  describe '#call' do
    context 'when the user is found' do
      it 'updates the user password' do
        expect { service }.to(change { user.reload.password_digest })
      end

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end
    end

    context 'when the user is not found' do
      let(:params) { { id: 0, password_challenge: 'Abcd@1234', password: 'Abcd@1234', password_confirmation: 'Abcd@1234' } }

      it 'gives user not found error' do
        expect(service.errors).to include(I18n.t('services.users.update_password.user_not_found'))
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the password and password confirmation do not match' do
      let(:params) do
        { id: user.id, password_challenge: 'Abcd@1234', password: 'Abcd@1234', password_confirmation: 'Abcd@12345' }
      end

      it 'does not update the user password' do
        expect { service }.not_to(change { user.reload.password_digest })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the password is invalid' do
      let(:params) do
        { id: user.id, password_challenge: 'Abcd@1234', password: 'abcd1234', password_confirmation: 'abcd1234' }
      end

      it 'does not update the user password' do
        expect { service }.not_to(change { user.reload.password_digest })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the password challenge is invalid' do
      let(:params) do
        { id: user.id, password_challenge: 'Abcd@12345', password: 'Abcd@1234', password_confirmation: 'Abcd@1234' }
      end

      it 'does not update the user password' do
        expect { service }.not_to(change { user.reload.password_digest })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
