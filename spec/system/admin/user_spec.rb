require 'rails_helper'

describe 'User', type: :system do
  include AuthenticationHelpers, UIHelpers, NavigationHelpers, FormHelpers

  let(:user) { create(:user, role_id: Role.find_by(name: "Admin").id) }

  context 'Creating a new user with valid credentials' do
    it 'shows the new user in the user list' do
      sign_in_as(user)
      go_to_admin_users_new
      fill_in_user_form(
        email_address: 'testaccount@testing.com',
        first_name: 'Test',
        last_name: 'Tester',
        role: 'User',
        password: 'Password1!'
      )
      click_and_expect(:button, 'Create User', '/admin/users')
      expect_page_content('User created successfully', user.email_address)
    end
  end

  context 'Viewing unactivated users' do
    it 'allows you to resend an activation email to the user' do
      user2 = create(:user, role_id: Role.find_by(name: "User").id, email_confirmed: false)
      sign_in_as(user)
      go_to_admin_users
      expect_page_content(user2.email_address, 'Resend Activation Email')
      click_and_expect(:button, 'Resend Activation Email', '/admin/users')
      expect_page_content(user2.email_address, 'Resend Activation Email', 'Activation email resent')

      reset_token = user.password_reset_token

      visit edit_password_path(token: reset_token)
      expect(page).to have_content('Update your password', wait: 10)
      expect(page).to have_current_path("/passwords/#{reset_token}/edit", wait: 10)
    end
  end
end
