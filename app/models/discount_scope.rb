class DiscountScope < ApplicationRecord
  belongs_to :discount
  belongs_to :shop, optional: true
end
