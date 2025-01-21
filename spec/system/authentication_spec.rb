require 'rails_helper'

RSpec.configure do |config|
  config.include TestHelpers, type: :system
end

describe 'Authentication', type: :system do
  context 'Sign-up with valid credentials' do
    it 'sends an activation email to the user' do
      visit signup_path
      expect(page).to have_current_path('/signup', wait: 10)
      fill_in 'user_email_address', with: 'exampleemail1093@gmail.com'
      fill_in 'user_password', with: 'Password1!'
      fill_in 'user_password_confirmation', with: 'Password1!'
      click_button 'Create User'
      expect(page).to have_current_path('/session/new', wait: 10)
      expect(page).to have_content('Please confirm your email address to continue.')
    end
  end

  context 'Sign-up with invalid credentials' do
    context 'Email validation' do
      it 'does not allow submission with an invalid email address' do
        visit signup_path
        expect(page).to have_current_path('/signup', wait: 10)
        fill_in 'user_email_address', with: 'invalid-email'
        fill_in 'user_password', with: 'Password1!'
        fill_in 'user_password_confirmation', with: 'Password1!'
        click_button 'Create User'
        expect(page).to have_current_path('/signup', wait: 10)
      end

      it 'does not allow submission when the email address is already taken' do
        create(:user, email_address: 'takenemail@test.com')
        visit signup_path
        expect(page).to have_current_path('/signup', wait: 10)
        fill_in 'user_email_address', with: 'takenemail@test.com'
        fill_in 'user_password', with: 'Password1!'
        fill_in 'user_password_confirmation', with: 'Password1!'
        click_button 'Create User'
        expect(page).to have_current_path('/signup', wait: 10)
      end
    end

    context 'password' do
      [
        { message: 'confirmation does not match the password', value: 'Password1!', confirmation: 'no-match' },
        { message: 'is too short (less than 8 characters)', value: 'Passw1!', confirmation: 'Passw1!' },
        { message: 'lacks lowercase letters', value: 'PASSWORD1!', confirmation: 'PASSWORD1!' },
        { message: 'lacks uppercase letters', value: 'password1!', confirmation: 'password1!' },
        { message: 'lacks numbers', value: 'Password!', confirmation: 'Password!' },
        { message: 'lacks symbols', value: 'Password1', confirmation: 'Password1' }
      ].each do |password|
        include_examples 'invalid password submission', password
      end
    end
  end

  context 'Login with valid credentials' do
    it 'redirects to the index page' do
      user = create(:user)
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      expect(page).to have_content('Tickets')
    end
  end

  context 'Login with invalid credentials' do
    it 'denies access and displays an error message' do
      user = create(:user, password: "Password1!")
      user.password = "incorrect-password"
      sign_in_as(user)
      expect(page).to have_current_path('/session/new', wait: 10)
      expect(page).to have_content('Try another email address or password.')
    end
  end

  context 'Logout process' do
    it 'successfully signs the user out' do
      user = create(:user)
      sign_in_as(user)
      expect(page).to have_current_path('/', wait: 10)
      click_button 'Log out'
      expect(page).to have_current_path('/session/new', wait: 10)
    end
  end
end
