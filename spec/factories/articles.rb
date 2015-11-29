FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    keywords { Faker::Lorem.words(3).join(", ") }

    factory :published_article do
      published true
    end

    factory :invalid_article do
      title nil
    end
  end
end