require 'rails_helper'

describe "Support API", type: :request do
  describe "GET /support/home" do
    it "renders the support home page" do
      get "/support/home"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Home")

      get "/support"
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/support/home")
    end
  end
end
