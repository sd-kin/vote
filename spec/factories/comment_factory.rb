# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    association :author, factory: :user
    association :commentable, factory: :valid_poll

    sequence(:body) { |n| "comment number #{n} " }

    trait :with_comments do
      after :create do |comment|
        FactoryGirl.create_list(:comment, 3, commentable_id: comment.id, commentable_type: 'Comment')
      end
    end

    trait :belongs_to_comment do
      association :commentable, factory: :comment
    end

    trait :with_image do
      after :create do |comment|
        comment.images.create(image_file: File.new('spec/fixtures/files/test_image.png'))
      end
    end
  end
end
