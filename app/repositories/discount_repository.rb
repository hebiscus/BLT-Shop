module Repositories
  class DiscountRepository
    def applicable_discounts(shop_id:)
      Discount.active.for_shop(shop_id)
    end
  end
end
