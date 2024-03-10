require 'clockwork'
require 'active_support/time'
include Clockwork # rubocop:disable Style/MixinUsage

handler do |job|
  puts "Running #{job}"
end

every(1.minute, 'hello.world') { puts 'Hello, world!' }

every(1.day, 'destroy.soft_deleted_users', at: '12:05') do
  DestroySoftDeletedUsersJob.perform_later
end
