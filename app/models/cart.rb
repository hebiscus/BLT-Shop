class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  def cart_total_price
    cart_items.sum(&:charged_price)
  end
end
