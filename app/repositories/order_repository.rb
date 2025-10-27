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

        file_path = ::OrderFaxFileGenerator.new(order).call
        ::FaxSender.new(file_path, receiver_number: "1234567890", token: ENV["FAX_API_TOKEN"]).call

        order
      end
    end
  end
end
