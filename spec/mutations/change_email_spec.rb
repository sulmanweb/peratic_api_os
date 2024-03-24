require 'rails_helper'

RSpec.describe Mutations::ChangeEmail, type: :request do
  let(:query) do
    <<~GQL
      mutation($input: ChangeEmailInput!) {
        changeEmail(input: $input) {
          errors
          success
        }
      }
    GQL
  end

  let(:user) { create(:user) }
  let(:headers) { sign_in_test_headers(user) }
  let(:variables) do
    {
      input: {
        passwordChallenge: 'Abcd@1234',
        email: Faker::Internet.email
      }
    }
  end

  describe 'change_email' do
    context 'when valid' do
      it 'returns success' do
        post('/graphql', params: { query:, variables: variables.to_json }, headers:)
        json = JSON.parse(response.body)
        success = json['data']['changeEmail']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post('/graphql', params: { query:, variables: variables.to_json }, headers:)
        json = JSON.parse(response.body)
        errors = json['data']['changeEmail']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:variables) do
        {
          input: {
            passwordChallenge: 'Abce@12345',
            email: Faker::Internet.email
          }
        }
      end

      it 'returns an unsuccessful result' do
        post('/graphql', params: { query:, variables: variables.to_json }, headers:)
        json = JSON.parse(response.body)
        success = json['data']['changeEmail']['success']

        expect(success).to be_falsey
      end
    end
  end
end
