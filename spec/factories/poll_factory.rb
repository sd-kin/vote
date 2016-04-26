FactoryGirl.define do
  factory :poll do
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
      options FactoryGirl.create_list(:valid_option, 3)
    end

    trait :with_updated_options do
      options FactoryGirl.create_list(:valid_option, 4)
    end

    factory :valid_poll, traits: [:with_title, :with_options]
    factory :updated_poll, traits: [:with_updated_title, :with_updated_options]
  end
end
