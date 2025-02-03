module UserHelpers
  def fill_user_form(email_address:, role:, password:)
    fill_in 'user_email_address', with: email_address
    select role, from: 'user_role_id'
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    expect(page).to have_select('user_role_id', selected: role)
  end

  def navigate_to_users
    visit root_path
    click_and_expect(:link, 'Admin', '/admin')
    click_and_expect(:link, 'Users', '/admin/users')
  end
end
