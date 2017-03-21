FactoryGirl.define do
  factory :category do
    name Faker::Lorem.word

    factory :article_with_words do
      name 'article'
      transient do
        words ['la','lo','le']
      end

      after(:create) do |category, evaluator|
        evaluator.words.each { |w| create(:word, phrase: w, category: category) }
      end
    end

    factory :name_with_words do
      name 'name'
      transient do
        words ['casa','auto','hombre', 'mujer']
      end

      after(:create) do |category, evaluator|
        evaluator.words.each { |w| create(:word, phrase: w, category: category) }
      end
    end
  end
end
