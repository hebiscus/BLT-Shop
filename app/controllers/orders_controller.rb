class OrdersController < ApplicationController
  def create
    # temporary selected shop id
    shop_id = session[:selected_shop_id]
    order_schema = OrderSchema.call(params.require(:order).permit!.to_h.merge(shop_id: shop_id))

    if order_schema.success?
      begin
        order = build_order!(order_schema, shop_id)

        current_cart.cart_items.destroy_all
        flash[:notice] = "Order placed successfully!"
        Rails.logger.info("Order successfully placed: #{order.id}")
        redirect_to "/sandwiches"
      rescue => e
        Rails.logger.error("[Order Error] #{e.class}: #{e.message}")
        render html: "Fatal error, details: #{e.message} <a href='#{request.referer}'>Go Back</a>".html_safe
      end
    else
      flash[:errors] = order_schema.errors
      redirect_to "/cart", allow_other_host: true
    end
  end

  private

  def build_order!(order_schema, shop_id)
    ActiveRecord::Base.transaction do
      order = Order.create!(
        delivery_method: order_schema[:delivery_method],
        delivery_time: order_schema[:delivery_time],
        order_status: order_schema[:order_status],
        shop_id: shop_id
      )

      current_cart.cart_items.each do |cart_item|
        order.order_items.create!(
          sandwich_id: cart_item.sandwich_id,
          quantity: cart_item.quantity,
          charged_price: cart_item.charged_price
        )
      end

      file_path = ::OrderFaxFileGenerator.new(order).call
      ::FaxSender.new(file_path, receiver_number: "1234567890", token: ENV["FAX_API_TOKEN"]).call

      order
    end
  end
end
