class Discount < ApplicationRecord
  has_many :discount_scopes, dependent: :destroy
  has_many :shops, through: :discount_scopes

  scope :currently_valid, -> {
    now = Time.current
    where(active: true)
      .where("starts_at IS NULL OR starts_at <= ?", now)
      .where("ends_at IS NULL OR ends_at >= ?", now)
  }

  # discount is applicable for shop if discount scope matches the shop_id or if global
  scope :for_shop, ->(shop_id) {
    left_outer_joins(:discount_scopes)
      .where(
        "discount_scopes.shop_id = :sid OR discount_scopes.id IS NULL",
        sid: shop_id
      )
  }

  def global?
    discount_scopes.none?
  end

  def local?
    discount_scopes.any?
  end
end
