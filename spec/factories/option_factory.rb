# frozen_string_literal: true

FactoryGirl.define do
  factory :option do
    trait :with_title do
      sequence(:title) { |n| "#{n.ordinalize} option" }
    end

    trait :with_description do
      sequence(:description) { |n| "This is #{n.ordinalize} option" }
    end

    factory :valid_option, traits: %i[with_title with_description]
  end
end
