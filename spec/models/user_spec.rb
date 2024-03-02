# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  deleted_at         :datetime
#  email              :string           not null
#  email_confirmed_at :datetime
#  name               :string
#  password_digest    :string
#  username           :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email) UNIQUE
#  index_users_on_username    (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'traits' do
    it 'has :confirmed trait' do
      expect(build(:user, :confirmed)).to be_valid
    end

    it 'has :deleted trait' do
      expect(build(:user, :deleted)).to be_valid
    end
  end

  describe 'validations' do
    describe 'email' do
      it 'is required' do
        expect(build(:user, email: nil)).not_to be_valid
      end

      it 'is unique' do
        user = create(:user)
        expect(build(:user, email: user.email)).not_to be_valid
      end

      it 'is in valid format' do
        expect(build(:user, email: 'invalid_email')).not_to be_valid
      end

      it 'is normalized' do
        user = create(:user, email: 'SULMANWEB@GMAIL.COM ')
        expect(user.email).to eq('sulmanweb@gmail.com')
      end
    end

    describe 'username' do
      it 'is required' do
        expect(build(:user, username: nil)).not_to be_valid
      end

      it 'is unique' do
        user = create(:user)
        expect(build(:user, username: user.username)).not_to be_valid
      end

      it 'is in valid format' do
        expect(build(:user, username: 'invalid username')).not_to be_valid
      end

      it 'is normalized' do
        user = create(:user, username: 'SulmanWeb ')
        expect(user.username).to eq('sulmanweb')
      end
    end

    describe 'name' do
      it 'is required' do
        expect(build(:user, name: nil)).not_to be_valid
      end
    end

    describe 'password' do
      it 'is required' do
        expect(build(:user, password: nil)).not_to be_valid
      end

      it 'is at least 8 characters long' do
        expect(build(:user, password: 'Abcd@12')).not_to be_valid
      end

      it 'is at most 72 characters long' do
        expect(build(:user, password: 'Abcd@1234' * 10)).not_to be_valid
      end

      it 'is in valid format' do
        expect(build(:user, password: 'abcd1234')).not_to be_valid
      end
    end
  end

  describe 'methods' do
    describe '#confirmed?' do
      it 'returns true if email_confirmed_at is present' do
        user = create(:user, :confirmed)
        expect(user).to be_confirmed
      end

      it 'returns false if email_confirmed_at is not present' do
        user = create(:user)
        expect(user).not_to be_confirmed
      end
    end

    describe '#confirm!' do
      it 'sets email_confirmed_at to current time' do
        user = create(:user)
        user.confirm!
        expect(user.email_confirmed_at).to be_present
      end
    end
  end
end
