require 'rails_helper'

RSpec.describe Mutations::ConfirmEmail, type: :request do
  let(:query) do
    <<~GQL
      mutation($input: ConfirmEmailInput!) {
        confirmEmail(input: $input) {
          errors
          success
          user {
            id
            email
            name
            username
          }
        }
      }
    GQL
  end
  let(:user) { create(:user) }
  let(:variables) { { input: { token: user.generate_token_for(:email_confirmation) } }.to_json }

  describe 'confirm_email' do
    context 'when valid' do
      it 'confirms the email' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        data = json['data']['confirmEmail']['user']

        expect(data['email']).to eq(user.email)
      end

      it 'returns success' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        success = json['data']['confirmEmail']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['confirmEmail']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:variables) { { input: { token: 'invalid' } }.to_json }

      it 'returns errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['confirmEmail']['errors']

        expect(errors).not_to be_empty
      end
    end
  end
end
