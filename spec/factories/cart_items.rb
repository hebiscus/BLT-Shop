FactoryBot.define do
  factory :cart_item do
    association :cart
    association :sandwich
    quantity { 1 }
    charged_price { 0 }
  end
end
