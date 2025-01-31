module TicketHelpers
  def fill_ticket_form(title:, description:, status:)
    fill_in 'Title', with: title
    fill_in 'Description', with: description
    select status, from: 'ticket_status_id'
    expect(page).to have_select('ticket_status_id', selected: status)
  end

  def update_ticket(title: nil, description: nil)
    fill_in 'Title', with: title if title
    fill_in 'Description', with: description if description
    click_button 'Update Ticket'
  end
end
