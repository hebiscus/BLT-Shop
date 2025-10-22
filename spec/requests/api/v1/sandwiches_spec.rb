require "rails_helper"

RSpec.describe "API::V1::Sandwiches", type: :request do
  describe "GET /api/v1/sandwiches" do
    it "returns all sandwiches" do
      create_list(:sandwich, 3)
      get "/api/v1/sandwiches"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /api/v1/sandwiches/:id" do
    it "returns a specific sandwich" do
      sandwich = create(:sandwich, name: "BLT")
      get "/api/v1/sandwiches/#{sandwich.id}"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["name"]).to eq("BLT")
    end
  end
end
