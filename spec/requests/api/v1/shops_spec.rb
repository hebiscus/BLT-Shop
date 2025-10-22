require "rails_helper"

RSpec.describe "API::V1::Shops", type: :request do
  describe "GET /api/v1/shops" do
    it "returns all shops" do
      create_list(:shop, 3)
      get "/api/v1/shops"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
