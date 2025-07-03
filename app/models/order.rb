class Order < ApplicationRecord
  has_many :order_items
  belongs_to :shop

  def total_amount
    order_items.sum { |item| item.charged_price * item.quantity }
  end
end
