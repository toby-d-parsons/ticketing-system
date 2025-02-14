module NavigationHelpers
  def go_to_support_tickets_index
    click_and_expect(:link, "Portal Home", "/support/home")
    click_and_expect(:link, "Tickets", "/support/tickets")
  end

  def go_to_support_tickets_new
    click_and_expect(:link, "Portal Home", "/support/home")
    click_and_expect(:link, "Tickets", "/support/tickets")
    click_and_expect(:link, "New Ticket", "/support/tickets/new")
  end

  def go_to_workspace_dashboard
    click_and_expect(:link, "Dashboard", "/workspace/dashboard")
  end

  def go_to_workspace_tickets
    click_and_expect(:link, "Dashboard", "/workspace/dashboard")
    click_and_expect(:link, "Tickets", "/workspace/tickets")
  end

  def go_to_workspace_tickets_new
    click_and_expect(:link, "Dashboard", "/workspace/dashboard")
    click_and_expect(:link, "Tickets", "/workspace/tickets")
    click_and_expect(:link, "New", "/workspace/tickets/new")
  end

  def go_to_workspace_tickets_edit(ticket)
    click_and_expect(:link, "Dashboard", "/workspace/dashboard")
    click_and_expect(:link, "Tickets", "/workspace/tickets")
    within("#row-#{ticket.id}") do
      click_and_expect(:link, "Edit", "/workspace/tickets/#{ticket.id}/edit")
    end
  end

  def navigate_to_users
    visit root_path
    click_and_expect(:link, 'Admin', '/admin')
    click_and_expect(:link, 'Users', '/admin/users')
  end
end
