RSpec.describe "Orders", type: :request do
  describe "POST /orders" do
    xit "returns http success" do
      post "/orders"
      expect(response).to have_http_status(:success)
    end
  end
end
