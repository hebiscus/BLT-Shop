class CartsController < ApplicationController
  def show
    cart_items = current_cart.cart_items.includes(:sandwich)
    total_price_cents = cart_items.sum(&:charged_price)

    render :show, locals: {cart_items:, total_price_cents:}
  end
end
