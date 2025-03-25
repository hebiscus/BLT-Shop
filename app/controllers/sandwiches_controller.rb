class SandwichesController < ApplicationController
  def new
    render :new, locals: { sandwich: Sandwich.new }
  end

  def create
    sandwich = Sandwich.new(sandwich_params)

    if sandwich.save
      redirect_to "/"
    else
      render :new, locals: { sandwich: sandwich }, status: :unprocessable_entity
    end
  end

  private 
  def sandwich_params
    params.require(:sandwich).permit(:name, :price)
  end
end
