class SandwichesController < ApplicationController
  def new
    render :new, locals: { sandwich: Sandwich.new }
  end

  def create
  end
end
