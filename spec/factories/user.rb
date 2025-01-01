FactoryBot.define do
  factory :user do
    email_address { "test_@gmail.com" }
    password { "passworD12£$" }
    role
  end
end
