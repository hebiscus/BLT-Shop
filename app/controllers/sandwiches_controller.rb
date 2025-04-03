class SandwichesController < ApplicationController
  before_action :authenticate
  def new
    render :new, locals: {sandwich: Sandwich.new}
  end

  def create
    sandwich = Sandwich.new(sandwich_params)

    if sandwich.save
      redirect_to "/"
    else
      render :new, locals: {sandwich: sandwich}, status: :unprocessable_entity
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
