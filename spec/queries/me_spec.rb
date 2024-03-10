require 'rails_helper'

RSpec.describe 'Me', type: :request do
  let(:user) { create(:user) }
  let(:headers) { sign_in_test_headers(user) }

  let(:query) do
    <<~GQL
      query {
        me {
          id
          name
          email
        }
      }
    GQL
  end

  context 'when the user is authenticated' do
    it 'returns the current user' do
      post('/graphql', params: { query: }, headers:)

      json = JSON.parse(response.body)
      data = json['data']['me']

      expect(data['id']).to eq(user.id.to_s)
      expect(data['email']).to eq(user.email)
    end
  end

  context 'when the user is not authenticated' do
    let(:headers) { {} }

    it 'returns an error' do
      post('/graphql', params: { query: }, headers:)

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq(I18n.t('gql.unauthenticated'))
    end
  end

  context 'when user is soft deleted' do
    before { user.destroy }

    it 'returns an error' do
      post('/graphql', params: { query: }, headers:)

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq(I18n.t('gql.unauthenticated'))
    end
  end
end
