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
FactoryBot.define do
  factory :email do
    to_emails { [Faker::Internet.email] }
    from_name { 'Peratic' }
    from_email { 'no-reply@peratic.com' }
    substitutions { { name: Faker::Name.name } }
    template_id { 'd-1234567890' }
  end
end
