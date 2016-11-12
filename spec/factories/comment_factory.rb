# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    association :author, factory: :user

    sequence(:body) { |n| "comment number #{n} " }

    trait :with_comments do
      after :create do |comment|
        FactoryGirl.create_list(:comment, 3, commentable_id: comment.id, commentable_type: 'Comment')
      end
    end

    trait :belongs_to_poll do
      association :commentable, factory: :valid_poll
    end
  end
end
