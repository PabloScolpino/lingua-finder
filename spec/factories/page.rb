FactoryGirl.define do
  factory :page do
    link Faker::Internet.url
    body Faker::Lorem.paragraph
  end
end
