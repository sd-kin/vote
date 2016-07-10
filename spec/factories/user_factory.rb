# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "mail_addres#{n}@domain.test" }
  end
end
