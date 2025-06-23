class OrdersController < ApplicationController
  def create
    order_schema = OrderSchema.call(params.require(:order).permit!.to_h)

    if order_schema.success?
      ActiveRecord::Base.transaction do
        order = Order.create!(
          delivery_method: order_schema[:delivery_method],
          delivery_time: order_schema[:delivery_time],
          order_status: order_schema[:order_status]
        )

        current_cart.cart_items.each do |cart_item|
          order.order_items.create!(
            sandwich_id: cart_item.sandwich_id,
            quantity: cart_item.quantity,
            charged_price: cart_item.charged_price
          )
        end

        file_path = ::OrderFaxFileGenerator.new(order).call

        ::FaxSender.new(
          file_path,
          receiver_number: "1234567890",
          token: ENV["FAX_API_TOKEN"]
        ).call
      end
      current_cart.cart_items.destroy_all
      flash[:notice] = "Order placed successfully!"
      redirect_to "/sandwiches"
    else
      flash[:errors] = order_schema.errors
      redirect_to "/cart", allow_other_host: true
    end
  end
end
