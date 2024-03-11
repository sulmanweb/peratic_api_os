require 'rails_helper'

RSpec.describe Mutations::SendResetPassword, type: :request do
  let(:user) { create(:user) }
  let(:query) do
    <<~GQL
      mutation($input: SendResetPasswordInput!) {
        sendResetPassword(input: $input) {
          errors
          success
        }
      }
    GQL
  end
  let(:variables) { { input: { auth: user.email } }.to_json }

  describe 'send_reset_password' do
    context 'when valid with email' do
      it 'returns success' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        success = json['data']['sendResetPassword']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['sendResetPassword']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when valid with username' do
      let(:variables) { { input: { auth: user.username } }.to_json }

      it 'returns success' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        success = json['data']['sendResetPassword']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['sendResetPassword']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:variables) { { input: { auth: 'invalid' } }.to_json }

      it 'returns an error' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['sendResetPassword']['errors']

        expect(errors).to be_nil
      end
    end
  end
end
