FactoryBot.define do
  factory :mission do
    name {Faker::Lorem.sentence(word_count: 5)}
    content {Faker::Lorem.sentence(word_count: 20)}
    sequence(:created_at){|d| Faker::Date.backward(days: d)}
  end
end