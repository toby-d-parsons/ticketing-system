require 'rails_helper'

describe "Workspace Tickets API", type: :request do
  include ResponseMatchers

  context "as an admin" do
    include_context "logged in as an admin"

    let!(:ticket) { create(:ticket) }

    context "DELETE /workspace/tickets/:id" do
      it "deletes the ticket" do
        delete "/workspace/tickets/#{ticket.id}"
        expect(response).to have_http_status(:found)

        get "/workspace/tickets/#{ticket.id}"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "as an agent" do
    include_context "logged in as a support agent"

    let!(:ticket) { create(:ticket) }
    let!(:ticket2) { create(:ticket) }
    let!(:ticket3) { create(:ticket) }

    context "GET /workspace/tickets" do
      it "returns a list of all tickets" do
        get "/workspace/tickets"

        expect(response).to have_http_status(:ok)
        expect_response_content(ticket.title, ticket2.title, ticket3.title)
      end
    end

    context "POST /workspace/tickets" do
      let!(:status) { create(:status, name: "Open") }

      it "creates a new ticket and increases the ticket count when valid values are submitted" do
        new_params =
        {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: status.id,
            user_id: user.id
          }
        }

        expect {
          post "/workspace/tickets", params: new_params
        }.to change(Ticket, :count).by(1)

        expect(response).to have_http_status(:redirect)
      end

      it "does not create a new ticket when invalid values are submitted" do
        new_params =
        {
          ticket: {
            title: "",
            description: "test description",
            status_id: status.id,
            user_id: user.id
          }
        }

        expect {
          post "/workspace/tickets", params: new_params
        }.to change(Ticket, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "PATCH /workspace/tickets/:id" do
      it "updates the ticket when valid values are submitted" do
        new_params = {
          ticket: {
            title: "newly patched title",
            description: ticket.description,
            status_id: ticket.status_id,
            assigned_agent_id: ticket.assigned_agent_id
          }
        }

        patch "/workspace/tickets/#{ticket.id}", params: new_params
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(workspace_tickets_path)
      end

      it "does not update the ticket when invalid values are submitted" do
        new_params = {
          ticket: {
            title: "",
            description: ticket.description,
            status_id: ticket.status_id,
            assigned_agent_id: ticket.assigned_agent_id
          }
        }

        patch "/workspace/tickets/#{ticket.id}", params: new_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "DELETE /workspace/tickets/:id" do
      it "cannot delete the ticket" do
        delete "/workspace/tickets/#{ticket.id}"

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context "as a user" do
    include_context "logged in as user"

    context "GET /workspace/tickets" do
      it "cannot access the agent workspace tickets page" do
        get "/workspace/tickets"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context "unauthenticated" do
    describe "GET /workspace/tickets" do
      it "fails to render the agent workspace tickets page" do
        get "/workspace/tickets"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
