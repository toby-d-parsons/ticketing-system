require 'rails_helper'

describe "Support Ticket Comments API", type: :request do
  include ResponseMatchers

  context "as a user" do
    include_context "logged in as user"

    let!(:user_ticket) { create(:ticket, requester: user, title: "This is a test") }
    let!(:user_ticket2) { create(:ticket, requester: user, title: "A completely random string") }
    let!(:other_user_ticket) { create(:ticket) }

    describe "POST support/tickets/:ticket_id/comments" do
      let(:valid_attributes) do
        {
          comment: {
            content: "Test content",
            user_id: user.id
          }
        }
      end

      it "allows the ticket creator to add a comment and displays it" do
        post "/support/tickets/#{user_ticket.id}/comments", params: valid_attributes

        new_comment = Comment.last
        expect(new_comment.ticket).to eq(user_ticket)
        expect(new_comment.content).to eq(valid_attributes[:comment][:content])

        expect(response).to have_http_status(:found)
      end

      it "prevents a non-creator from adding a comment" do
        expect {
          post "/support/tickets/#{other_user_ticket.id}/comments", params: valid_attributes
        }.to change(Comment, :count).by(0)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context "unauthenticated" do
    let!(:other_user_ticket) { create(:ticket) }

    describe "POST support/tickets/:ticket_id/comments" do
      let!(:other_user) { create(:user) }
      let(:valid_attributes) do
        {
          comment: {
            content: "Test content",
            user_id: other_user.id
          }
        }
      end

      it "fails to create a comment" do
        expect {
          post "/support/tickets/#{other_user_ticket.id}/comments", params: valid_attributes
        }.to change(Comment, :count).by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
