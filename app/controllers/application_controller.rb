class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_cart
    @current_cart ||= begin
      cart = Cart.includes(:cart_items).find_by(id: session[:cart_id])
      unless cart
        cart = Cart.create!
        session[:cart_id] = cart.id
      end
      cart
    end
  end
end
