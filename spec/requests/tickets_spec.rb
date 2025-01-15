require 'rails_helper'

describe "Tickets API", type: :request do
  context "as a User" do
    include_context "logged in as user"

    let(:status) { create(:status) }
    let(:current_user_ticket) { create(:ticket, title: "Ticket One", user_id: user.id) }
    let(:current_user_ticket2) { create(:ticket, title: "Ticket Two", user_id: user.id) }
    let(:other_user) { create(:user) }
    let(:other_user_ticket) { create(:ticket, user: other_user) }

    context "GET /tickets" do
      it "returns ticket list details of their own tickets" do
        current_user_ticket
        current_user_ticket2
        other_user_ticket
        get "/tickets"

        expect(response).to have_http_status(200)
        expect(response.body).to include(current_user_ticket.title)
        expect(response.body).to include(current_user_ticket2.title)
        expect(response.body).not_to include(other_user_ticket.title)
      end

      context "when no tickets exist" do
        it "returns an empty ticket details list" do
          get "/tickets"

          expect(response).to have_http_status(200)
          expect(response.body).not_to include(current_user_ticket.title)
          expect(response.body).not_to include(other_user_ticket.title)
        end
      end
    end

    context "GET /tickets/:id" do
      it "can access their own tickets" do
        get "/tickets/#{current_user_ticket.id}"

        expect(response).to have_http_status(200)
        expect(response.body).to include("Ticket One")
      end

      context "when accessing a ticket that belongs to another user" do
        it "returns a 403 Forbidden status" do
          get "/tickets/#{other_user_ticket.id}"

          expect(response).to have_http_status(403)
        end
      end
    end

    context "POST /tickets" do
      include_context "logged in as user"

      let(:status) { create(:status) }

      it "creates a new ticket and increases the ticket count" do
        valid_attributes = {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: status.id,
            user_id: user.id
          }
        }

        expect {
          post "/tickets", params: valid_attributes
        }.to change(Ticket, :count).by(1)

        expect(response).to have_http_status(:found)
      end
    end
  end

  context "as an Admin" do
    include_context "logged in as an admin"

    let(:status) { create(:status) }
    let(:ticket) { create(:ticket, title: "Ticket One", user_id: user.id) }
    let(:other_user) { create(:user) }
    let(:other_user_ticket) { create(:ticket, user: other_user) }

    context "GET /tickets" do
      it "returns ticket list details" do
        ticket
        other_user_ticket
        get "/tickets"

        expect(response).to have_http_status(200)
        expect(response.body).to include(ticket.title)
        expect(response.body).to include(other_user_ticket.title)
      end

      context "when no tickets exist" do
        it "returns an empty ticket details list" do
          get "/tickets"

          expect(response).to have_http_status(200)
          expect(response.body).not_to include(ticket.title)
          expect(response.body).not_to include(other_user_ticket.title)
        end
      end
    end

    context "GET /tickets/:id" do
      it "can access their own tickets" do
        get "/tickets/#{ticket.id}"

        expect(response).to have_http_status(200)
        expect(response.body).to include(ticket.title)
      end

      it "can access tickets belonging to another user" do
        get "/tickets/#{other_user_ticket.id}"

        expect(response).to have_http_status(200)
        expect(response.body).to include(other_user_ticket.title)
      end

      context "when the ticket does not exist" do
        it "returns a 404 Not Found status" do
          get "/tickets/500000000000000" # Assumes that a ticket with this id does not exist

          expect(response).to have_http_status(404)
        end
      end
    end
  end

  context "when signed out" do
    context "GET /tickets" do
      it "returns 302 Found status and redirects to login page" do
        get "/tickets"

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "POST /tickets" do
      let(:status) { create(:status) }
      let(:user) { create(:user) }

      it "returns 302 Found status and redirects to login page" do
        valid_attributes = {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: status.id,
            user_id: user.id
          }
        }

        expect {
          post "/tickets", params: valid_attributes
        }.to_not change(Ticket, :count)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
