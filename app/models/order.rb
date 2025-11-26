class Order < ApplicationRecord
  has_many :order_items
  belongs_to :shop

  # to delete
  def total_amount
    order_items.sum { |item| item.charged_price * item.quantity }
  end

  def total_price_before_discount
    order_items.sum { |item| item.charged_price * item.quantity }
  end
end
