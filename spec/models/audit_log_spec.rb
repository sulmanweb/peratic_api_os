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
require 'rails_helper'

RSpec.describe AuditLog, type: :model do
  it 'has a valid factory' do
    expect(build(:audit_log)).to be_valid
  end

  describe 'soft delete' do
    it 'soft deletes the audit log' do
      audit_log = create(:audit_log)
      expect { audit_log.destroy }.to change(described_class.only_deleted, :count).by(1)
      expect(audit_log.deleted_at).not_to be_nil
    end
  end
end
