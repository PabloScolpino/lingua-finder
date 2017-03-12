FactoryGirl.define do
  factory :search do
    query "durante la <?>"
    country_code  "AR"
    user
  end
end
