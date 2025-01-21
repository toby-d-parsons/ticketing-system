RSpec.shared_examples 'invalid password submission' do |password|
  it "does not allow submission when the password #{password[:message]}" do
    visit signup_path
    expect(page).to have_current_path('/signup', wait: 10)

    fill_in 'user_email_address', with: 'exampleemail1093@gmail.com'
    fill_in 'user_password', with: password[:value]
    fill_in 'user_password_confirmation', with: password[:confirmation]
    click_button 'Create User'

    expect(page).to have_current_path('/signup', wait: 10)
  end
end
