# == Schema Information
#
# Table name: audit_logs
#
#  id         :bigint           not null, primary key
#  class_name :string
#  data       :jsonb            not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_audit_logs_on_class_name  (class_name)
#  index_audit_logs_on_data        (data) USING gin
#  index_audit_logs_on_deleted_at  (deleted_at)
#  index_audit_logs_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :audit_log do
    user
    class_name { 'MyString' }
  end
end
