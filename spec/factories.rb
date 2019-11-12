FactoryBot.define do
<<<<<<< HEAD
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password {"password"}
    password_confirmation {"password"}

    factory :user_with_missions do
      transient do
        missions_count {10}
      end

      after(:create) do |user, evaluator|
        create_list(:mission, evaluator.missions_count, user: user)
      end
    end
  end

=======
>>>>>>> 9673d253983a17637aab563bcdfa1ecd11bf92dd
  factory :mission do
    name {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..48))}
    content {Faker::Lorem.paragraph_by_chars(number: Random.rand(8..254))}
    sequence(:created_at){|d| DateTime.now + d }
    deadline { Faker::Date.between(from: created_at.tomorrow, to: created_at.tomorrow+100)}
    work_state { %w[ waiting progressing completed ].sample }
    priority { %w[low medium high ].sample }
<<<<<<< HEAD
    association :user
=======
>>>>>>> 9673d253983a17637aab563bcdfa1ecd11bf92dd

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