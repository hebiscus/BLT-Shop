class OrdersController < ApplicationController
  def create
    order_schema = OrderSchema.call(params.require(:order).permit!.to_h)

    if order_schema.success?
      ActiveRecord::Base.transaction do
        order = Order.create!(
          delivery_method: order_schema[:delivery_method],
          delivery_time: order_schema[:delivery_time],
          order_status: order_schema[:order_status]
        )
      end
      flash[:notice] = "Order placed successfully!"
      redirect_to "/sandwiches"
    else
      flash[:errors] = order_schema.errors
      redirect_to "/cart", allow_other_host: true
    end
  end
end
