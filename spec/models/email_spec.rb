# == Schema Information
#
# Table name: emails
#
#  id            :bigint           not null, primary key
#  from_email    :string
#  from_name     :string
#  substitutions :jsonb
#  to_emails     :string           default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  template_id   :string
#
# Indexes
#
#  index_emails_on_substitutions  (substitutions) USING gin
#
require 'rails_helper'

RSpec.describe Email, type: :model do
  it 'has a valid factory' do
    expect(build(:email)).to be_valid
  end

  describe 'validations' do
    describe 'to_emails' do
      it 'is invalid when empty' do
        expect(build(:email, to_emails: [])).not_to be_valid
      end
    end

    describe 'from_email' do
      it 'is invalid when empty' do
        expect(build(:email, from_email: '')).not_to be_valid
      end
    end

    describe 'from_name' do
      it 'is invalid when empty' do
        expect(build(:email, from_name: '')).not_to be_valid
      end
    end

    describe 'template_id' do
      it 'is invalid when empty' do
        expect(build(:email, template_id: '')).not_to be_valid
      end
    end
  end

  describe 'create_confirmation_email!' do
    it 'creates a confirmation email' do
      user = create(:user)
      email = described_class.create_confirmation_email!(user:)
      expect(email.to_emails).to eq([user.email])
    end
  end

  describe 'create_reset_password_email!' do
    it 'creates a reset password email' do
      user = create(:user)
      email = described_class.create_reset_password_email!(user:)
      expect(email.to_emails).to eq([user.email])
    end
  end
end
