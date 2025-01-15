RSpec.shared_context "logged in as user", shared_context: :metadata do
  email_address = "person100@example.com"
  password = "passworD12£$"

  let!(:user) { create(:user, email_address: email_address, password: password) }

  before do
    post "/session", params: { email_address: email_address, password: password }
  end
end
