# frozen_string_literal: true

FactoryBot.define do
  factory :google_custom_search_api_result, class: Hash do
    items { [] }

    initialize_with { attributes.with_indifferent_access }

    trait :with_results do
      transient do
        result_count { 2 }
      end
      items { result_count.times.each_with_object([]) { |n, a| a << { 'link' => "http://example.com/page#{n}.html" } } }
    end
  end
end
