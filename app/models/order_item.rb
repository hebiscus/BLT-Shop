class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sandwich

  def sandwich_name
    sandwich.name
  end
end
