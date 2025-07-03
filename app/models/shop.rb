class Shop < ApplicationRecord
  has_many :shop_sandwiches
  has_many :sandwiches, through: :shop_sandwiches

  validates :name, presence: true
end
