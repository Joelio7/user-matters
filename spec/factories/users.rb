FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    firm_name { Faker::Company.name }
    phone { Faker::PhoneNumber.unique.phone_number }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
