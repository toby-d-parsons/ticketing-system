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
end
