# frozen_string_literal: true

FactoryBot.define do
  factory :search_query do
    string { 'durante la' }
    config {
      {
        cr: 'countryAR',
        language: 'es-AR',
        fileType: '-pdf'
      }
    }

    performed { false }

    trait :performed do
      transient do
        page_count { 2 }
      end

      after :create do |search_query, evaluator|
        search_query.pages = evaluator.create_list(:page, evaluator.page_count)
      end
    end
  end
end
