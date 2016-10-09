# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "comment number #{n} " }

    trait :with_comments do
      after :create do |comment|
        FactoryGirl.create_list(:comment, 3, commentable_id: comment.id, commentable_type: 'Comment')
      end
    end
  end
end
