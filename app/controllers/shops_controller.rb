class ShopsController < ApplicationController
  def choose_shop
    if params[:shop_id].empty?
      sandwiches = Sandwich.all
      no_sandwiches_msg = "No sandwiches anywhere!" if sandwiches.empty?
    else
      session[:selected_shop_id] = params[:shop_id]
      selected_shop = Shop.find(session[:selected_shop_id])
      sandwiches = selected_shop.sandwiches
      no_sandwiches_msg = "No sandwiches available for #{selected_shop.name}." if sandwiches.empty?
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "sandwiches_list",
          partial: "sandwiches/list",
          locals: {sandwiches: sandwiches,
                   no_sandwiches_msg: no_sandwiches_msg}
        )
      end
    end
  end
end
