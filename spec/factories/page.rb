# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    link { 'http://www.example.com/page.html' }

    trait :with_content do
      body { Faker::Lorem.paragraph }
    end
  end
end
