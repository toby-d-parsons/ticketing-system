require 'rails_helper'

describe "Workspace API", type: :request do
  context "as an agent" do
    include_context "logged in as a support agent"

    describe "GET /workspace/dashboard" do
      it "renders the agent workspace dashboard page" do
        get "/workspace/dashboard"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Dashboard")
        expect(response.body).to include("Tickets")

        get "/workspace"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/workspace/dashboard")
      end
    end
  end

  context "as a user" do
    include_context "logged in as user"

    describe "GET /workspace/dashboard" do
      it "cannot access the agent workspace dashboard page" do
        get "/workspace/dashboard"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context "unauthenticated" do
    describe "GET /workspace/dashboard" do
      it "fails to render the agent workspace dashboard page" do
        get "/workspace/dashboard"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
