require 'rails_helper'

RSpec.describe Mutations::SelfDestroy, type: :request do
  let(:query) do
    <<~GQL
      mutation {
        selfDestroy(input: {}) {
          errors
          success
        }
      }
    GQL
  end

  let(:user) { create(:user) }
  let(:headers) { sign_in_test_headers(user) }

  describe 'self_destroy' do
    context 'when valid' do
      it 'returns success' do
        post('/graphql', params: { query: }, headers:)
        json = JSON.parse(response.body)
        success = json['data']['selfDestroy']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post('/graphql', params: { query: }, headers:)
        json = JSON.parse(response.body)
        errors = json['data']['selfDestroy']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:headers) { {} }

      it 'returns an error' do
        post('/graphql', params: { query: }, headers:)
        json = JSON.parse(response.body)
        errors = json['errors']

        expect(errors.first['message']).to eq(I18n.t('gql.unauthenticated'))
      end
    end
  end
end
