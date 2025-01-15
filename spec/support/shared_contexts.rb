RSpec.shared_context "logged in as user", shared_context: :metadata do
  email_address = "person100@example.com"
  password = "passworD12£$"

  let!(:user) { create(:user, email_address: email_address, password: password, role_id: 3) } # role_id: 3 is hardcoded for User role

  before do
    post "/session", params: { email_address: email_address, password: password }
  end
end

RSpec.shared_context "logged in as an admin", shared_context: :metadata do
  email_address = "person10000@example.com"
  password = "passworD12£$"

  let!(:user) { create(:user, email_address: email_address, password: password, role_id: 1) } # role_id: 1 is hardcoded for Admin role

  before do
    post "/session", params: { email_address: email_address, password: password }
  end
end
