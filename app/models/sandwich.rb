class Sandwich < ApplicationRecord
  has_many :order_items
  has_many :shop_sandwiches
  has_many :shops, through: :shop_sandwiches

  validates :name, :price, presence: true
end
