require 'rails_helper'

RSpec.describe Users::ChangeUsernameService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) do
    { id: user.id, username: Faker::Internet.unique.username(separators: %w[. _ -], specifier: 3..20),
      password_challenge: 'Abcd@1234' }
  end

  describe '#call' do
    context 'when the user is found' do
      it 'updates the user username' do
        expect { service }.to(change { user.reload.username })
      end

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end
    end

    context 'when the user is not found' do
      let(:params) do
        { id: 0, username: Faker::Internet.unique.username(separators: %w[. _ -], specifier: 3..20),
          password_challenge: 'Abcd@1234' }
      end

      it 'gives user not found error' do
        expect(service.errors).to include(I18n.t('services.users.change_username.user_not_found'))
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the username is invalid' do
      let(:params) { { id: user.id, username: 'invalid username', password_challenge: 'Abcd@1234' } }

      it 'does not update the user username' do
        expect { service }.not_to(change { user.reload.username })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when password challenge is invalid' do
      let(:params) do
        { id: user.id, username: Faker::Internet.unique.username(separators: %w[. _ -], specifier: 3..20),
          password_challenge: 'abcd1234' }
      end

      it 'does not update the user username' do
        expect { service }.not_to(change { user.reload.username })
      end
    end
  end
end
