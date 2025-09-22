FactoryBot.define do
  factory :order do
    shop
    delivery_method { "self_pickup" }
    delivery_time { 1.hour.from_now }
    order_status { "pending" }

    transient do
      items_count { 0 }
      sandwich { create(:sandwich) }
    end

    after(:create) do |order, evaluator|
      create_list(:order_item, evaluator.items_count, order: order, sandwich: evaluator.sandwich)
    end
  end
end
