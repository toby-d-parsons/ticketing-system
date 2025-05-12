module NavigationHelpers
  def go_to_passwords_new
    visit new_session_path
    click_and_expect(:link, "Forgot password", "/passwords/new")
  end

  def go_to_support_tickets_index
    click_and_expect(:testid, "support-link", "/support/home")
    click_and_expect(:link, "Tickets", "/support/tickets")
  end

  def go_to_support_tickets_new
    click_and_expect(:testid, "support-link", "/support/home")
    click_and_expect(:link, "Tickets", "/support/tickets")
    click_and_expect(:link, "New Ticket", "/support/tickets/new")
  end

  def go_to_workspace_dashboard
    click_and_expect(:testid, "dashboard-link", "/workspace/dashboard")
  end

  def go_to_workspace_tickets
    click_and_expect(:testid, "workspace-link", "/workspace/tickets")
  end

  def go_to_workspace_tickets_new
    click_and_expect(:testid, "workspace-link", "/workspace/tickets")
    click_and_expect(:link, "New", "/workspace/tickets/new")
  end

  def go_to_workspace_tickets_edit(ticket)
    click_and_expect(:testid, "workspace-link", "/workspace/tickets")
    within("#row-#{ticket.id}") do
      click_and_expect(:link, ticket.id, "/workspace/tickets/#{ticket.id}/edit")
    end
  end

  def go_to_admin_users
    click_and_expect(:testid, 'admin-link', '/admin')
    click_and_expect(:link, 'Users', '/admin/users')
  end

  def go_to_admin_users_new
    click_and_expect(:testid, 'admin-link', '/admin')
    click_and_expect(:link, 'Users', '/admin/users')
    click_and_expect(:link, 'New', '/admin/users/new')
  end
end
