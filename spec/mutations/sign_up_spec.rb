require 'rails_helper'

RSpec.describe Mutations::SignUp, type: :request do
  let(:query) do
    <<~GQL
      mutation($input: SignUpInput!) {
        signUp(input: $input) {
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
  let(:attributes) { attributes_for(:user) }
  let(:variables) { { input: attributes.deep_transform_keys! { |key| key.to_s.camelize(:lower) } }.to_json }

  describe 'sign_up' do
    context 'when valid' do
      it 'creates a new user' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        data = json['data']['signUp']['user']

        expect(data['email']).to eq(attributes['email'])
      end

      it 'returns success' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        success = json['data']['signUp']['success']

        expect(success).to be_truthy
      end

      it 'returns no errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['signUp']['errors']

        expect(errors).to be_nil
      end
    end

    context 'when invalid' do
      let(:attributes) { attributes_for(:user, email: '') }

      it 'returns errors' do
        post '/graphql', params: { query:, variables: }
        json = JSON.parse(response.body)
        errors = json['data']['signUp']['errors']

        expect(errors).not_to be_empty
      end
    end
  end
end
