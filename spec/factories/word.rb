# frozen_string_literal: true

FactoryBot.define do
  factory :word do
    phrase { Faker::Lorem.word }
    category
  end
end
