class SandwichesController < ApplicationController
  before_action :authenticate

  def index
    sandwiches = Sandwich.all
    shops = Shop.all

    render :index, locals: {sandwiches: sandwiches, shops:}
  end

  def show
    sandwich = Sandwich.find(params[:id])
    shops = Shop.all

    render :show, locals: {sandwich:, shops:}
  end

  def new
    render :new, locals: {sandwich: Sandwich.new}
  end

  def create
    sandwich = Sandwich.new(sandwich_params)

    if sandwich.save
      redirect_to "/"
    else
      Rails.logger.error("Creating a sandwich failed: #{sandwich.errors.full_messages}")
      render :new, locals: {sandwich: sandwich}, status: :unprocessable_entity
    end
  end

  def add_to_cart
    sandwich = Sandwich.find(params[:id])
    quantity = params[:quantity].to_i

    raw_params = {
      sandwich_id: sandwich.id,
      quantity: quantity,
      charged_price: sandwich.price * quantity
    }

    result = CartItemSchema.call(raw_params)

    if result.success?
      current_cart.cart_items.create!(
        sandwich_id: result[:sandwich_id],
        quantity: result[:quantity],
        charged_price: result[:charged_price]
      )

      redirect_to sandwich_path(sandwich), notice: "Added to cart"
    else
      Rails.logger.error("Adding an item to cart failed: #{result.errors.to_h}")
      redirect_to sandwich_path(sandwich), alert: "Could not save item to cart"
    end
  end

  private

  def sandwich_params
    params.require(:sandwich).permit(:name, :price)
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USERNAME"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
