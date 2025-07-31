# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

CartItem.delete_all
Cart.delete_all
OrderItem.delete_all
Order.delete_all
ShopSandwich.delete_all
Sandwich.delete_all
Shop.delete_all

cities = [
  {name: "Warsaw", address: {street: "Nowy Świat 1", city: "Warsaw", postal_code: "00-001"}},
  {name: "Kraków", address: {street: "Floriańska 2", city: "Kraków", postal_code: "31-001"}},
  {name: "Łódź", address: {street: "Piotrkowska 3", city: "Łódź", postal_code: "90-001"}},
  {name: "Wrocław", address: {street: "Rynek 4", city: "Wrocław", postal_code: "50-001"}},
  {name: "Poznań", address: {street: "Święty Marcin 5", city: "Poznań", postal_code: "60-001"}},
  {name: "Gdańsk", address: {street: "Długa 6", city: "Gdańsk", postal_code: "80-001"}},
  {name: "Szczecin", address: {street: "Aleja Piastów 7", city: "Szczecin", postal_code: "70-001"}}
]

shops = cities.map do |city|
  Shop.create!(name: "Sandwich Spot - #{city[:name]}", address: city[:address])
end

sandwiches = [
  {name: "Classic Ham", price: 12},
  {name: "Veggie Delight", price: 10},
  {name: "Chicken Avocado", price: 14},
  {name: "Tuna Melt", price: 13},
  {name: "Italian BMT", price: 15}
]

created_sandwiches = sandwiches.map { |s| Sandwich.create!(s) }

shops.each do |shop|
  sample = created_sandwiches.sample(rand(2..4))
  sample.each do |sandwich|
    ShopSandwich.create!(shop: shop, sandwich: sandwich)
  end
end

puts "Seeded #{shops.count} shops and #{created_sandwiches.count} sandwiches."
