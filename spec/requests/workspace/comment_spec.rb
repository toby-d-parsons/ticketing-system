require 'rails_helper'

describe "Workspace Ticket Comments API", type: :request do
  context "as an agent" do
    include_context "logged in as a support agent"

    let!(:ticket) { create(:ticket) }

    describe "POST workspace/tickets/:ticket_id/comments" do
      let(:valid_attributes) do
        {
          comment: {
            content: "Test content",
            user_id: user.id
          }
        }
      end

      it "allows an agent to add a comment and displays it" do
        post "/workspace/tickets/#{ticket.id}/comments", params: valid_attributes

        new_comment = Comment.last
        expect(new_comment.ticket).to eq(ticket)
        expect(new_comment.content).to eq(valid_attributes[:comment][:content])

        expect(response).to have_http_status(:found)
      end
    end
  end

  context "unauthenticated" do
    let!(:ticket) { create(:ticket) }

    describe "POST workspace/tickets/:ticket_id/comments" do
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
          post "/workspace/tickets/#{ticket.id}/comments", params: valid_attributes
        }.to change(Comment, :count).by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
