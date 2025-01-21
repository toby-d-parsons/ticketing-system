require 'rails_helper'

RSpec.configure do |config|
  config.include TestHelpers, type: :system
end

describe 'Index', type: :system do
  it 'shows the login page' do
    visit new_session_path
    expect(page).to have_content('Forgot password?')
  end
  describe 'index page' do
    it 'shows the index' do
      user = create(:user)
      sign_in_as(user)
      sleep(1)
      expect(page).to have_content('Tickets')
    end
  end
end
