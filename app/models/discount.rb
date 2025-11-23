class Discount < ApplicationRecord
  has_many :discount_scopes, dependent: :destroy
  has_many :shops, through: :discount_scopes
end
