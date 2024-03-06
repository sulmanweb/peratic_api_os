require 'rails_helper'

RSpec.describe Users::SignInService do
  subject(:service) { described_class.call(params) }

  let(:user) { create(:user) }
  let(:params) { { username: user.username, password: user.password } }

  describe '#call' do
    context 'when the user is valid' do
      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end

      it 'returns the user and token' do
        expect(service.data[:user]).to eq(user)
        expect(service.data[:token]).to be_present
      end

      it 'creates an audit log' do
        expect { service }.to change(AuditLog, :count).by(1)
      end
    end

    context 'when the user is invalid' do
      let(:params) { { username: 'invalid', password: 'invalid' } }

      it 'returns an error result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
