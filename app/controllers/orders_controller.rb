class OrdersController < ApplicationController
  def create
    order_schema = OrderSchema.call(params.require(:order).permit!.to_h)

    if order_schema.success?
      ActiveRecord::Base.transaction do
        order = Order.create!(
          delivery_method: order_schema[:delivery_method],
          delivery_time: order_schema[:delivery_time]
        )

        order_schema[:order_items].each do |item|
          order.order_items.create!(
            sandwich_id: item[:sandwich_id],
            quantity: item[:quantity]
          )
        end

        render json: {id: order.id}, status: :created
      end
    else
      render json: {errors: order_schema.errors.to_h}, status: :unprocessable_entity
    end
  end
end
