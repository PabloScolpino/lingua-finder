FactoryBot.define do
  factory :word do
    phrase { Faker::Lorem.word }
    category
  end
end
