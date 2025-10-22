module Api
  module V1
    class ShopsController < ApplicationController
      def index
        render json: Shop.all
      end
    end
  end
end
