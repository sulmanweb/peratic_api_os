require 'rails_helper'

RSpec.describe Mutations::UpdatePassword, type: :request do
  let(:query) do
    <<~GQL
      mutation($input: UpdatePasswordInput!) {
        updatePassword(input: $input) {
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
        password: 'Amal@1234',
        passwordConfirmation: 'Amal@1234'
      }
    }.to_json
  end

  describe 'update_password' do
    context 'when valid' do
      it 'returns success' do
        post('/graphql', params: { query:, variables: }, headers:)
        json = JSON.parse(response.body)
        success = json['data']['updatePassword']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post('/graphql', params: { query:, variables: }, headers:)
        json = JSON.parse(response.body)
        errors = json['data']['updatePassword']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:variables) do
        {
          input: {
            passwordChallenge: 'Abce@1234',
            password: 'Abcd@1234',
            passwordConfirmation: 'Abcd@1234'
          }
        }.to_json
      end

      it 'returns an unsuccessful result' do
        post('/graphql', params: { query:, variables: }, headers:)
        json = JSON.parse(response.body)
        success = json['data']['updatePassword']['success']

        expect(success).to be_falsey
      end
    end
  end
end
