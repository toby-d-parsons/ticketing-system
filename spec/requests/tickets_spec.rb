require 'rails_helper'

describe "Tickets API", type: :request do
  context "When logged in as a user" do
    context "GET /tickets/:id" do
      # it "returns details of a ticket raised by the user"
      # it "prevents access to tickets that belong to another user"
    end

    context "POST /tickets" do
      include_context "logged in as user"

      it "creates a new ticket and increases the ticket count" do
        @status = create(:status)

        valid_attributes = {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: @status.id,
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

  context "When signed out" do
    context "GET /tickets" do
      it "returns a list of tickets" do
        create(:ticket, title: "Ticket One")
        create(:ticket, title: "Ticket Two")

        get "/tickets"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Ticket One")
        expect(response.body).to include("Ticket Two")
      end
    end

    context "GET /tickets/:id" do
      it "returns a 404 error when the ticket does not exist" do
        get "/tickets/50000000000000000"

        expect(response).to have_http_status(404)
      end
    end

    context "POST /tickets" do
      it "does not create a ticket, however path is found and redirects to login page" do
        @status = create(:status)
        @user = create(:user)

        valid_attributes = {
          ticket: {
            title: "test title",
            description: "test description",
            status_id: @status.id,
            user_id: @user.id
          }
        }

        expect {
          post "/tickets", params: valid_attributes
        }.to_not change(Ticket, :count)

        expect(response).to have_http_status(:found)

        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
