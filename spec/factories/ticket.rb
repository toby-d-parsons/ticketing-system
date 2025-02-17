FactoryBot.define do
  factory :ticket do
      title { "random title" }
      description { "random text" }
      status
      association :requester, factory: :user
  end
end
