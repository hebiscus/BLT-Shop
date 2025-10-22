module Api
  module V1
    class OrdersController < ApplicationController
      def create
        order = Order.new(order_params)

        if order.save
          params[:order_items]&.each do |item|
            order.order_items.create!(
              sandwich_id: item[:sandwich_id],
              quantity: item[:quantity],
              charged_price: item[:charged_price] || Sandwich.find(item[:sandwich_id]).price
            )
          end

          render json: order, status: :created
        else
          render json: {errors: order.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def show
        order = Order.includes(:order_items).find(params[:id])
        render json: order.as_json(include: {order_items: {include: :sandwich}})
      end

      private

      def order_params
        params.require(:order).permit(:delivery_method, :delivery_time, :shop_id)
      end
    end
  end
end
