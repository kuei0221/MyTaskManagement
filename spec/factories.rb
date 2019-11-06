FactoryBot.define do
  factory :mission do
    name {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..48))}
    content {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..254))}
    sequence(:created_at){|d| DateTime.now + d }
    deadline { Faker::Date.forward(days: 365)}
  end
end