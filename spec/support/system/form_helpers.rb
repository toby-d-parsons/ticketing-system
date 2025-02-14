module FormHelpers
  def fill_in_ticket_form_from_support_page(title:, description:)
    fill_in "Title", with: title
    fill_in "Description", with: description
  end

  def fill_in_ticket_form_from_workspace_page(title:, description:, status:, assigned_agent:)
    fill_in "Title", with: title
    fill_in "Description", with: description
    select status, from: "ticket_status_id"
    select assigned_agent, from: "ticket_assigned_agent_id"
  end

  def fill_in_comment(content)
    fill_in "comment_content", with: content
  end

  def fill_in_user_form(email_address:, role:, password:)
    fill_in 'user_email_address', with: email_address
    select role, from: 'user_role_id'
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    expect(page).to have_select('user_role_id', selected: role)
  end
end
