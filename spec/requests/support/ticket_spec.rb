require 'rails_helper'

describe "Support Tickets API", type: :request do
  include ResponseMatchers

  context "as a user" do
    include_context "logged in as user"

    let!(:user_ticket) { create(:ticket, requester: user, title: "This is a test") }
    let!(:user_ticket2) { create(:ticket, requester: user, title: "A completely random string") }
    let!(:other_user_ticket) { create(:ticket) }

    describe "GET /support/tickets" do
      it "renders the tickets page with only the user's tickets listed" do
        get "/support/tickets"
        expect(response).to have_http_status(:ok)
        expect_response_content("Tickets", user_ticket.title, user_ticket2.title)
        expect(response.body).to_not include(other_user_ticket.title)
      end
    end

    describe "GET /support/tickets/:id" do
      it "can access their own tickets" do
        get "/support/tickets/#{user_ticket.id}"
        expect(response).to have_http_status(:ok)
        expect_response_content(user_ticket.id, user_ticket.title, user_ticket.description)
      end

      it "cannot access other users' tickets" do
        get "/support/tickets/#{other_user_ticket.id}"
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "POST /support/tickets" do
      let!(:status) { create(:status, name: "Open") }
      let(:valid_attributes) do
        {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: status.id,
            user_id: user.id
          }
        }
      end

      it "creates a new ticket and increases the ticket count" do
        expect {
          post "/support/tickets", params: valid_attributes
        }.to change(Ticket, :count).by(1)

        expect(response).to have_http_status(:redirect)
      end
    end

    describe "DELETE /support/tickets/:id" do
      it "will not delete a ticket as route does not exist" do
        delete "/support/ticket/#{user_ticket.id}"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "unauthenticated" do
    describe "GET /support/tickets" do
      it "fails to render the tickets page" do
        get "/support/tickets"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "POST /support/tickets" do
      let!(:user) { create(:user) }
      let!(:status) { create(:status, name: "Open") }
      let(:valid_attributes) do
        {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: status.id,
            user_id: user.id
          }
        }
      end

      it "fails to create a new ticket" do
        post "/support/tickets", params: valid_attributes

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
