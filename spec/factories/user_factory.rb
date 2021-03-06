# frozen_string_literal: true
FactoryGirl.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:email) { |n| "mail_addres#{n}@domain.test" }

  factory :user do
    username
    email

    password { "#{username}password" }
    password_confirmation { password }

    trait :with_notifications do
      after :create do |user|
        FactoryGirl.create_list(:notification, 3, user: user)
      end
    end
  end
end
