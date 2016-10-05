# frozen_string_literal: true
namespace :poll do
  desc "set status expired polls to closed"
  task finish_expired: :environment do
    Poll.where('expire_at <= :date', date: DateTime.now).map(&:closed!)
  end
end
