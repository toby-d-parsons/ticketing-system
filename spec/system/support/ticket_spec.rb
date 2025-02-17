require 'rails_helper'

describe "Ticket", type: :system do
  include AuthenticationHelpers, UIHelpers, FormHelpers, NavigationHelpers

  let(:user) { create(:user, role: Role.find_by(name: "User")) }
  let!(:other_user_ticket) { create(:ticket) }

  context "Viewing tickets" do
    let!(:user_ticket) { create(:ticket, title: "this is a test woohoo", requester: user) }

    it "shows tickets created by the user but not those of other users" do
      sign_in_as(user)
      go_to_support_tickets_index
      expect(page).to have_selector("a", text: user_ticket.title, wait: 10)
      expect(page).to_not have_selector("a", text: other_user_ticket.title, wait: 10)
    end
  end

  context "Creating a new ticket" do
    it "successfully creates a new ticket and displays it in the ticket list" do
      sign_in_as(user)
      go_to_support_tickets_new

      title = "this is a title"

      fill_in_ticket_form_from_support_page(
        title: title,
        description: "I am a description."
      )

      click_and_expect(:button, "Create Ticket", "/support/tickets")
      expect(page).to have_selector("a", text: title, wait: 10)
      expect(page).to_not have_selector("a", text: other_user_ticket.title, wait: 10)
    end

    it "does not allow submission without a title, and retains the description" do
      sign_in_as(user)
      go_to_support_tickets_new

      fill_in_ticket_form_from_support_page(
        title: "",
        description: "I am a description."
      )

      click_and_expect(:button, "Create Ticket", "/support/tickets/new")
      expect(page).to have_field("ticket_description", with: "I am a description.", wait: 10)
    end

    it "does not allow submission without a description, and retains the title" do
      sign_in_as(user)
      go_to_support_tickets_new

      fill_in_ticket_form_from_support_page(
        title: "I am a title",
        description: ""
      )

      click_and_expect(:button, "Create Ticket", "/support/tickets/new")
      expect(page).to have_field("ticket_title", with: "I am a title", wait: 10)
    end
  end

  context "Unauthenticated access" do
    it "redirects unauthenticated users away from the tickets page" do
      visit root_path
      click_and_expect(:link, "Portal Home", "/support/home")
      click_and_expect(:link, "Tickets", "/session/new")
    end
  end

  context "Adding a comment" do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket, requester_id: user.id) }

    before do
      sign_in_as(user)
      go_to_support_tickets_index
      click_and_expect(:link, ticket.title, "/support/tickets/#{ticket.id}")
    end

    it "successfully adds a comment and displays it within the ticket" do
      fill_in 'comment_content', with: 'I am a comment'
      click_button 'Add Comment'
      expect(page).to have_current_path("/support/tickets/#{ticket.id}", wait: 10)
      expect(page).to have_content('I am a comment')
      expect(page).to have_content('Comment successfully added.')
    end

    it "does not create a comment if content is missing" do
      fill_in 'comment_content', with: ''
      click_button 'Add Comment'
      expect(page).to have_current_path("/support/tickets/#{ticket.id}", wait: 10)
      expect(page).to_not have_content(user.email_address)
    end
  end
end
