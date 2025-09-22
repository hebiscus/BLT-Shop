FactoryBot.define do
  factory :order_item do
    order
    sandwich
    quantity { 2 }
    charged_price { 999 }
  end
end
