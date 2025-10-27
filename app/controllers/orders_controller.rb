require_relative "../repositories/order_repository"

class OrdersController < ApplicationController
  def create
    # temporary selected shop id
    shop_id = session[:selected_shop_id]
    order_schema = OrderSchema.call(params.require(:order).permit!.to_h.merge(shop_id: shop_id))

    if order_schema.success?
      begin
        order_items = current_cart.cart_items
        order = repository.build_order!(order_params: order_schema.to_h, order_items:)

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

  def repository
    ::Repositories::OrderRepository.new
  end
end
