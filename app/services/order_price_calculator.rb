class OrderPriceCalculator
  def initialize(order:)
    @order = order
    @discount_repo = Repositories::DiscountRepository.new
  end

  def call
    total_before = @order.total_price_before_discount
    discounts = @discount_repo.applicable_discounts(shop_id: @order.shop_id)

    if discounts.any?
      best_discount = discounts.max_by(&:percentage)
      discount_amount = (total_before * best_discount.percentage / 100.0).round
      total_after = total_before - discount_amount
    else
      best_discount = nil
      discount_amount = 0
      total_after = total_before
    end

    {
      total_before_discount: total_before,
      total_after_discount: total_after,
      applied_discount: best_discount,
      discount_amount: discount_amount
    }
  end
end
