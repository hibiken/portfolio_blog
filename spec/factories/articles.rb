FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    keywords { Faker::Lorem.words(3).join(", ") }
  end
end