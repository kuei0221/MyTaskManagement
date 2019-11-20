FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    admin {false}
    role {"normal"}
    password {"password"}
    password_confirmation {"password"}

    trait :admin do
      admin {true}
    end

    trait :normal do
      role {"normal"}
    end

    trait :administrator do
      role {"administrator"}
    end

    factory :user_with_missions do
      transient do
        missions_count {10}
      end

      after(:create) do |user, evaluator|
        create_list(:mission, evaluator.missions_count, user: user)
      end
    end
  end

  factory :mission do
    name {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..48))}
    content {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..254))}
    sequence(:created_at){|d| DateTime.now + d }
    deadline { Faker::Date.between(from: created_at.tomorrow, to: created_at.tomorrow+100)}
    work_state { %w[ waiting progressing completed ].sample }
    priority { %w[low medium high ].sample }
    association :user

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