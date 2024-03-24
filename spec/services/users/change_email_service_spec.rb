require 'rails_helper'

RSpec.describe Users::ChangeEmailService do
  let(:service) { described_class.call(params) }
  let(:user) { create(:user) }
  let(:params) { { id: user.id, email: Faker::Internet.email, password_challenge: 'Abcd@1234' } }

  describe '#call' do
    context 'when the user is found' do
      it 'updates the user email' do
        expect { service }.to(change { user.reload.email })
      end

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end
    end

    context 'when the user is not found' do
      let(:params) { { id: 0, email: Faker::Internet.email, password_challenge: 'Abcd@1234' } }

      it 'gives user not found error' do
        expect(service.errors).to include(I18n.t('services.users.change_email.user_not_found'))
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the email is the same as the current email' do
      let(:params) { { id: user.id, email: user.email, password_challenge: 'Abcd@1234' } }

      it 'does not update the user email' do
        expect { service }.not_to(change { user.reload.email })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when the email is invalid' do
      let(:params) { { id: user.id, email: 'invalid_email', password_challenge: 'Abcd@1234' } }

      it 'does not update the user email' do
        expect { service }.not_to(change { user.reload.email })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end

    context 'when password challenge is invalid' do
      let(:params) { { id: user.id, email: Faker::Internet.email, password_challenge: 'abcd1234' } }

      it 'does not update the user email' do
        expect { service }.not_to(change { user.reload.email })
      end

      it 'returns an unsuccessful result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
