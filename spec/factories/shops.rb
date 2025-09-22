FactoryBot.define do
  factory :shop do
    name { "ShopTest" }
    address { {street: "A Street For Testing", city: "Krosno"} }
  end
end
