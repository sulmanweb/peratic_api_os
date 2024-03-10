require 'rails_helper'

RSpec.describe Users::DestroyFullyService do
  subject(:service) { described_class.call(params) }

  let(:user) { create(:user) }
  let(:params) { { id: user.id } }

  describe '#call' do
    context 'when the user is valid' do
      before { user.destroy }

      it 'returns a successful result' do
        expect(service.success).to be_truthy
      end

      it 'destroys the user' do
        expect { service }.to change(User.only_deleted, :count).by(-1)
      end
    end

    context 'when the user is invalid' do
      it 'returns an error result' do
        expect(service.success).to be_falsey
      end
    end
  end
end
