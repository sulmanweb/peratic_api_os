# DestroySoftDeletedUsersJob is a job that is responsible for destroying soft deleted users.
class DestroySoftDeletedUsersJob < ApplicationJob
  queue_as :default

  DELETION_TIME = 7.days

  def perform
    User.only_deleted.where('deleted_at < ?', DELETION_TIME.ago).find_each do |user|
      Users::DestroyFullyService.call({ id: user.id })
    end
  end
end
