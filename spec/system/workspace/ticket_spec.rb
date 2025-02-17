require 'rails_helper'

describe "Ticket", type: :system do
  include AuthenticationHelpers, UIHelpers, FormHelpers, NavigationHelpers

  let(:user) { create(:user, role: Role.find_by(name: "Support Agent")) }
  let(:admin) { create(:user, role: Role.find_by(name: "Admin")) }

  context "When visiting the tickets page" do
    it "shows a list of all tickets" do
      ticket = create(:ticket)

      sign_in_as(user)
      go_to_workspace_tickets
      expect_page_content("Title", "Description", "Status", "New", ticket.title)
    end
  end

  context "Creating a new ticket" do
    let!(:ticket_details) do
      {
        title: "Test title",
        description: "Test description",
        status: "Pending",
        assigned_agent: user.email_address
      }
    end
    it "successfully creates a new ticket and displays it in the ticket list" do
      sign_in_as(user)
      go_to_workspace_tickets_new
      fill_in_ticket_form_from_workspace_page(**ticket_details)

      click_and_expect(:button, "Create Ticket", "/workspace/tickets")
      expect(page).to have_selector("td", text: ticket_details[:title], wait: 10)
      expect(page).to have_selector("td", text: ticket_details[:description], wait: 10)
      expect(page).to have_selector("td", text: ticket_details[:status], wait: 10)
      expect(page).to have_selector("td", text: ticket_details[:assigned_agent], wait: 10)
    end

    it "does not allow submission without valid inputs" do
      ticket_details[:description] = ""

      sign_in_as(user)
      go_to_workspace_tickets_new
      fill_in_ticket_form_from_workspace_page(**ticket_details)

      click_and_expect(:button, "Create Ticket", "/workspace/tickets/new")
      expect(page).to have_field("ticket_title", with: ticket_details[:title], wait: 10)
    end
  end

  context "Editing an existing ticket" do
    let!(:ticket) { create(:ticket) }
    let!(:ticket2) { create(:ticket) }

    it "successfully updates the ticket with valid elements and displays it in the ticket list" do
      sign_in_as(user)
      go_to_workspace_tickets_edit(ticket)
      fill_in "Title", with: "Chicken"
      click_and_expect(:button, "Update Ticket", "/workspace/tickets")
      expect(page).to have_selector("td", text: "Chicken", wait: 10)
    end

    it "does not update the ticket without valid inputs, and retains the original content" do
      sign_in_as(user)
      go_to_workspace_tickets_edit(ticket)
      fill_in "Title", with: ""
      click_and_expect(:button, "Update Ticket", "/workspace/tickets/#{ticket.id}/edit")
      click_and_expect(:link, "Cancel", "/workspace/tickets")
      expect(ticket.title).to_not eq("")
      expect(page).to have_selector("td", text: ticket.title, wait: 10)
    end
  end

  context "Deleting a ticket" do
    let!(:ticket) { create(:ticket) }

    before do
      sign_in_as(admin)
    end

    it "deletes a ticket from the ticket list" do
      go_to_workspace_tickets
      click_button("Delete")
      accept_alert

      expect(page).to_not have_selector("td", text: ticket.title, wait: 10)
    end

    it "deletes a ticket from the edit page" do
      go_to_workspace_tickets_edit(ticket)
      click_button("Delete")
      accept_alert

      expect(page).to have_current_path("/workspace/tickets", wait: 10)
      expect(page).to_not have_selector("td", text: ticket.title, wait: 10)
    end
  end

  context "Adding a comment" do
    let!(:ticket) { create(:ticket) }

    it "successfully adds a comment and displays it within the ticket" do
      sign_in_as(user)
      go_to_workspace_tickets_edit(ticket)

      comment = "test data"
      fill_in_comment(comment)

      click_and_expect(:button, "Add Comment", "/workspace/tickets/#{ticket.id}/edit")
      expect_page_content(user.email_address, comment)
    end

    it "does not create a comment if content is missing"
    # sign_in_as(user)
    # go_to_workspace_tickets_edit(ticket)

    # comment = ""
    # fill_in_comment(comment)

    # click_and_expect(:button, "Add Comment", "/workspace/tickets/#{ticket.id}/edit")

    ### Above needs clearing up once an identifier has been apended to comments. Currently no appropriate way to identify if a comment has been added
  end
end
