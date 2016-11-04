# frozen_string_literal: true
FactoryGirl.define do
  factory :poll do
    user

    trait :with_title do
      title 'first poll'
    end

    trait :with_updated_title do
      title 'updated title'
    end

    trait :with_empty_title do
      title ''
    end

    trait :with_options do
      after :create do |poll|
        Option.skip_callback(:create, :after, :draft_poll!)
        FactoryGirl.create_list(:valid_option, 3, poll: poll)
        Option.set_callback(:create, :after, :draft_poll!)
      end
    end

    trait :with_updated_options do
      after :create do |poll|
        FactoryGirl.create_list(:valid_option, 4, poll: poll)
      end
    end

    trait :with_comments do
      after :create do |poll|
        FactoryGirl.create_list(:comment, 3, commentable_id: poll.id, commentable_type: 'Poll')
      end
    end

    factory :valid_poll, traits: [:with_title, :with_options]
    factory :updated_poll, traits: [:with_updated_title, :with_updated_options]
  end
end
