FactoryBot.define do
  factory :discount do
    sequence(:name) { |n| "Discount #{n}" }
    active { true }
    starts_at { nil }
    ends_at { nil }
    rules { {} }
    percentage { 50 }

    trait :expired do
      starts_at { 5.days.ago }
      ends_at { 1.day.ago }
    end

    trait :future do
      starts_at { 1.day.from_now }
      ends_at { 5.days.from_now }
    end

    trait :date_range do
      starts_at { 2.days.ago }
      ends_at { 2.days.from_now }
    end

    trait :with_rules do
      rules { {"min_order_total" => 2000} }
    end

    trait :inactive do
      active { false }
    end

    trait :local do
      transient do
        shop { create(:shop) }
      end

      after(:create) do |discount, evaluator|
        create(:discount_scope, discount: discount, shop: evaluator.shop)
      end
    end
  end
end
