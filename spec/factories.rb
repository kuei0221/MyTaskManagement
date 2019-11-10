FactoryBot.define do
  factory :mission do
    name {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..48))}
    content {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..254))}
    sequence(:created_at){|d| DateTime.now + d }
    deadline { Faker::Date.between(from: created_at.tomorrow, to: created_at.tomorrow+100)}
    work_state { %w[ waiting progressing completed ].sample }
    priority { %w[low medium high ].sample }

    trait :waiting do
      work_state { "waiting" }
    end
    trait :progressing do
      work_state { "progressing" }
    end
    trait :completed do
      work_state { "completed" }
    end

    trait :low_priority do
      priority { "low" }
    end

    trait :medium_priority do
      priority { "medium" }
    end

    trait :high_priority do
      priority { "high" }
    end
  end
end