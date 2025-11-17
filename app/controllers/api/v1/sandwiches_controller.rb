module Api
  module V1
    class SandwichesController < ApplicationController
      def index
        sandwiches = Sandwich.all
        render json: sandwiches
      end

      def show
        shop = Shop.includes(:sandwiches).find_by(name: params[:shop_name])
        sandwich = shop.sandwiches.find(params[:id])
        render json: sandwich
      end
    end
  end
end
