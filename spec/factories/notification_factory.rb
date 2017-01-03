# frozen_string_literal: true
FactoryGirl.define do
  factory :notification do
    user

    trait :about_poll do
      valid_poll
    end

    trait :about_comment do
      comment
    end

    factory :poll_notification, traits: [:about_poll]
    factory :comment_notification, traits: [:about_comment]
  end
end
