require 'rails_helper'

RSpec.describe Users::DestroyService do
  subject(:service) { described_class.call(params) }

  let(:user) { create(:user) }
  let(:params) { { id: user.id } }

  describe '#call' do
    context 'when the user is valid' do
      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end

      it 'destroys the user' do
        expect { service }.to change(User.only_deleted, :count).by(1)
      end

      it 'creates an audit log' do
        expect { service }.to change(AuditLog, :count).by(1)
      end
    end

    context 'when the user is invalid' do
      let(:params) { { id: nil } }

      it 'returns an error result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
