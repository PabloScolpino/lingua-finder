# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    link { Faker::Internet.url }
    body { Faker::Lorem.paragraph }
  end
end
