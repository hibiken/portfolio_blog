FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'secretpassword'
    password_confirmation 'secretpassword'
  end
end