module Api
  module V1
    class OrdersController < ApplicationController
      def create
        order = repository.build_order!(
          order_params: order_params.to_h,
          order_items: params[:order_items] || [],
          shop_id:
        )

        render json: order, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
      end

      def show
        order = Order.includes(:order_items).find(params[:id])
        render json: order.as_json(include: {order_items: {include: :sandwich}})
      end

      private

      def order_params
        params.require(:order).permit(:delivery_method, :delivery_time, :shop_id)
      end

      def repository
        ::Repositories::OrderRepository.new
      end
    end
  end
end
