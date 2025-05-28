FactoryBot.define do
  factory :user do
    sequence(:email_address) { "person#{_1}@example.com" }
    first_name { "Test" }
    last_name { "Tester" }
    password { "passworD12£$" }
    email_confirmed { true }
    role
  end
end
