FactoryBot.define do
  factory :ticket do
      title { "random title" }
      description { "random text" }
      status
      user
  end
end
