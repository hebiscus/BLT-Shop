module Repositories
  class OrderRepository
    def build_order!(order_params:, order_items:)
      ActiveRecord::Base.transaction do
        order = Order.create!(**order_params)
        order_items.each do |item|
          order.order_items.create!(
            sandwich_id: item[:sandwich_id],
            quantity: item[:quantity],
            charged_price: item[:charged_price] ||
                           Sandwich.find(item[:sandwich_id]).price
          )
        end

        apply_pricing_and_discounts(order)

        file_path = ::OrderFaxFileGenerator.new(order).call
        ::FaxSender.new(file_path, receiver_number: "1234567890", token: ENV["FAX_API_TOKEN"]).call

        order
      end
    end

    # temp; move into a separate PricingRepo
    def apply_pricing_and_discounts(order)
      pricing = OrderPriceCalculator.new(order: order).call

      # total after discount apply

      # register discount use
    end
  end
end
