module TicketHelpers
  def expect_path_and_click(expected_path, link, new_path)
    expect(page).to have_current_path(expected_path, wait: 10)
    click_link link
    expect(page).to have_current_path(new_path, wait: 10)
  end

  def click_and_expect_link(link, new_path)
    click_link link
    expect(page).to have_current_path(new_path, wait: 10)
  end

  def fill_ticket_form(title:, description:, status:)
    fill_in 'Title', with: title
    fill_in 'Description', with: description
    select status, from: 'ticket_status_id'
    expect(page).to have_select('ticket_status_id', selected: status)
  end

  def expect_page_content(*arr)
    arr.each { |n| expect(page).to have_content(n) }
  end

  def update_ticket(title: nil, description: nil)
    fill_in 'Title', with: title if title
    fill_in 'Description', with: description if description
    click_button 'Update Ticket'
  end
end
