require 'rails_helper'

RSpec.describe Mutations::SignIn, type: :request do
  let(:query) do
    <<~GQL
      mutation($input: SignInInput!) {
        signIn(input: $input) {
          errors
          success
          token
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
  let(:variables) { { input: { username: user.username, password: 'Abcd@1234' } }.to_json }

  describe 'sign_in' do
    context 'when valid' do
      it 'returns a token' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        token = json['data']['signIn']['token']

        expect(token).not_to be_nil
      end

      it 'returns success' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        success = json['data']['signIn']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['signIn']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:variables) { { input: { username: user.username, password: 'invalid' } }.to_json }

      it 'returns errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['signIn']['errors']

        expect(errors).not_to be_empty
      end
    end
  end
end
