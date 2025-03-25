class Sandwich < ApplicationRecord

  validates :name, :price, presence: true
end
