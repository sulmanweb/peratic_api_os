# spec/jobs/destroy_soft_deleted_users_job_spec.rb

require 'rails_helper'

RSpec.describe DestroySoftDeletedUsersJob, type: :job do
  include ActiveJob::TestHelper

  # Soft Deleted user
  let!(:first_user) { create(:user).tap { |u| u.update_columns(deleted_at: 32.days.ago) } } # rubocop:disable Rails/SkipsModelValidations

  # Non-soft-deleted user
  let!(:second_user) { create(:user) }

  # Soft deleted but within DELETION_TIME
  let!(:third_user) do
    create(:user).tap do |u|
      u.update_columns(deleted_at: 6.days.ago) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  describe 'Queueing the job' do
    it 'queues the job' do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue('default')
    end
  end

  describe 'Performing the job' do
    before do
      allow(Users::DestroyFullyService).to receive(:call)
      described_class.perform_now
    end

    it 'calls Users::DestroyFullyService for each soft deleted user older than DELETION_TIME' do
      expect(Users::DestroyFullyService).to have_received(:call).with({ id: first_user.id }).once
    end

    it 'does not call Users::DestroyFullyService for non-soft-deleted user' do
      expect(Users::DestroyFullyService).not_to have_received(:call).with({ id: second_user.id })
    end

    it 'does not call Users::DestroyFullyService for soft-deleted user within DELETION_TIME' do
      expect(Users::DestroyFullyService).not_to have_received(:call).with({ id: third_user.id })
    end
  end
end
