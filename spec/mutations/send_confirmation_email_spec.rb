require 'rails_helper'

RSpec.describe Mutations::SendConfirmationEmail, type: :request do
  let(:query) do
    <<~GQL
      mutation {
        sendConfirmationEmail(input: {}) {
          errors
          success
        }
      }
    GQL
  end

  let(:user) { create(:user) }
  let(:headers) { sign_in_test_headers(user) }

  describe 'send_confirmation_email' do
    context 'when valid' do
      it 'returns success' do
        post('/graphql', params: { query: }, headers:)
        json = JSON.parse(response.body)
        success = json['data']['sendConfirmationEmail']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post('/graphql', params: { query: }, headers:)
        json = JSON.parse(response.body)
        errors = json['data']['sendConfirmationEmail']['errors']

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

    context 'when user is already confirmed' do
      let(:user) { create(:user, :confirmed) }

      it 'returns an error' do
        post('/graphql', params: { query: }, headers:)
        json = JSON.parse(response.body)
        errors = json['data']['sendConfirmationEmail']['errors']

        expect(errors.first).to eq(I18n.t('services.users.send_confirmation.user_already_confirmed'))
      end
    end
  end
end
