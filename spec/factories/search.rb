# frozen_string_literal: true

FactoryBot.define do
  factory :search do
    query { 'durante la <?>' }
    country_code { 'AR' }
    user
  end
end
