require 'rails_helper'

RSpec.describe Mutations::ResetPassword, type: :request do
  let(:query) do
    <<~GQL
      mutation($input: ResetPasswordInput!) {
        resetPassword(input: $input) {
          errors
          success
        }
      }
    GQL
  end
  let(:user) { create(:user) }
  let(:variables) do
    { input: { token: user.generate_token_for(:password_reset), password: 'Abcd@1234',
               passwordConfirmation: 'Abcd@1234' } }.to_json
  end

  describe 'reset_password' do
    context 'when valid' do
      it 'resets the password' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        success = json['data']['resetPassword']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['resetPassword']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when token is invalid' do
      let(:variables) { { input: { token: 'invalid', password: 'Abcd@1234', passwordConfirmation: 'Abcd@1234' } }.to_json }

      it 'returns errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['resetPassword']['errors']

        expect(errors).not_to be_empty
      end
    end

    context 'when password and password confirmation do not match' do
      let(:variables) do
        { input: { token: user.generate_token_for(:password_reset), password: 'Abcd@1234',
                   passwordConfirmation: 'Abcd@12345' } }.to_json
      end

      it 'returns errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['resetPassword']['errors']

        expect(errors).not_to be_empty
      end
    end

    context 'when password is invalid' do
      let(:variables) do
        { input: { token: user.generate_token_for(:password_reset), password: 'abcd1234',
                   passwordConfirmation: 'abcd1234' } }.to_json

        it 'returns errors' do
          post '/graphql', params: { query:, variables: }
          json = JSON.parse(response.body)
          errors = json['data']['resetPassword']['errors']

          expect(errors).not_to be_empty
        end
      end
    end
  end
end
