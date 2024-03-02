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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    username { Faker::Internet.unique.username(separators: %w[. _ -]) }
    password { 'Abcd@1234' }

    trait :confirmed do
      email_confirmed_at { Time.current }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
