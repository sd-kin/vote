# encoding: utf-8
# frozen_string_literal: true
FactoryGirl.define do
  factory :option do
    trait :with_title do
      title 'option'
    end

    trait :with_description do
      description 'description'
    end

    factory :valid_option, traits: [:with_title, :with_description]
  end
end
