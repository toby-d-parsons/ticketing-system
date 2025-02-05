require 'rails_helper'

describe 'Ticket Management', type: :system do
  include UIHelpers, AuthenticationHelpers, TicketHelpers

  context 'Create a new ticket with valid inputs' do
    it 'successfully creates a new ticket and displays it in the ticket list' do
      user = create(:user)
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_and_expect(:link, 'New Ticket', '/tickets/new')

      fill_ticket_form(
        title: 'Test title',
        description: 'Test description',
        status: 'Pending'
      )

      click_button 'Create Ticket'
      expect(page).to have_current_path('/tickets/1', wait: 10)

      expect_page_content(
        'Test title',
        'Test description',
        'Pending'
      )
    end
  end

  context 'Create a new ticket with invalid inputs' do
    let(:user) { create(:user) }
    let(:ticket) { create(:ticket, user_id: user.id) }

    before do
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_and_expect(:link, 'New Ticket', '/tickets/new')
    end

    it 'does not allow submission when the title is missing' do
      fill_ticket_form(
        title: '',
        description: 'Test description',
        status: 'Pending'
      )

      click_button 'Create Ticket'
      expect(page).to have_current_path('/tickets/new', wait: 10)
    end

    it 'does not allow submission when the description is missing' do
      fill_ticket_form(
        title: 'Test title',
        description: '',
        status: 'Pending'
      )

      click_button 'Create Ticket'
      expect(page).to have_current_path('/tickets/new', wait: 10)
    end
  end

  context 'Edits a ticket with valid inputs' do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket, user_id: user.id) }

    before do
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_and_expect(:link, ticket.title, "/tickets/#{ticket.id}")
      click_and_expect(:link, 'Edit', "/tickets/#{ticket.id}/edit")
    end

    it 'successfully updates the ticket when the title is provided' do
      update_ticket(title: 'Updated Title')

      expect_page_content(
        'Updated Title',
        ticket.description,
        'Open',
        'Unassigned'
      )
    end

    it 'successfully updates the ticket when the description is provided' do
      update_ticket(description: 'Updated Description')

      expect_page_content(
        ticket.title,
        'Updated Description',
        'Open',
        'Unassigned'
      )
    end

    it 'successfully updates the ticket when the status is changed' do
      select 'Pending', from: 'ticket_status_id'
      click_button 'Update Ticket'

      expect_page_content(
        ticket.title,
        ticket.description,
        'Pending',
        'Unassigned'
      )
    end

    it 'successfully updates the ticket when the assigned agent is changed' do
      agent = create(:user, role_id: Role.find_by(name: "Support Agent").id)
      visit current_path
      select agent.email_address, from: 'ticket_assigned_agent_id'
      click_button 'Update Ticket'

      expect_page_content(
        ticket.title,
        ticket.description,
        'Open',
        agent.email_address
      )
    end
  end

  context 'Edits a ticket with invalid inputs' do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket, user_id: user.id) }

    before do
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_and_expect(:link, ticket.title, "/tickets/#{ticket.id}")
      click_and_expect(:link, 'Edit', "/tickets/#{ticket.id}/edit")
    end

    it 'does not update the ticket when the title is missing' do
      update_ticket(title: '')

      expect(page).to have_current_path("/tickets/#{ticket.id}/edit", wait: 10)
    end

    it 'does not update the ticket when the description is missing' do
      update_ticket(description: '')

      expect(page).to have_current_path("/tickets/#{ticket.id}/edit", wait: 10)
    end
  end

  context 'Delete a ticket' do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket, user_id: user.id) }

    before do
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_and_expect(:link, ticket.title, "/tickets/#{ticket.id}")
    end

    it 'successfully deletes a new ticket and removes it from the ticket list' do
      accept_confirm do
        click_button 'Delete'
      end
      expect(page).to have_current_path("/tickets", wait: 10)
      expect(page).to_not have_content(ticket.title)
    end
  end

  context 'Adding a comment' do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket, user_id: user.id) }

    before do
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_and_expect(:link, ticket.title, "/tickets/#{ticket.id}")
    end

    it 'successfully creates a comment and displays it within the ticket' do
      fill_in 'comment_content', with: 'I am a comment'
      click_button 'Add Comment'
      expect(page).to have_current_path("/tickets/#{ticket.id}", wait: 10)
      expect(page).to have_content('I am a comment')
      expect(page).to have_content('Comment successfully added.')
    end

    it 'does not create a comment when the content is missing' do
      fill_in 'comment_content', with: ''
      click_button 'Add Comment'
      expect(page).to have_current_path("/tickets/#{ticket.id}", wait: 10)
      expect(page).to_not have_content(user.email_address)
    end
  end
end
