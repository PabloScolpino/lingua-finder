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
  end
end
