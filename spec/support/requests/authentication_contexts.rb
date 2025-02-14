RSpec.shared_context "logged in as user", shared_context: :metadata do
  email_address = "person100@example.com"
  password = "passworD12£$"

  let!(:user) { create(:user, email_address: email_address, password: password, role_id: Role.find_by(name: "User").id) }

  before do
    post "/session", params: { email_address: email_address, password: password }
  end
end

RSpec.shared_context "logged in as a support agent", shared_context: :metadata do
  email_address = "person1001231200@example.com"
  password = "passworD12£$"

  let!(:user) { create(:user, email_address: email_address, password: password, role_id: Role.find_by(name: "Support Agent").id) }

  before do
    post "/session", params: { email_address: email_address, password: password }
  end
end

RSpec.shared_context "logged in as an admin", shared_context: :metadata do
  email_address = "person10000@example.com"
  password = "passworD12£$"

  let!(:user) { create(:user, email_address: email_address, password: password, role_id: Role.find_by(name: "Admin").id) }

  before do
    post "/session", params: { email_address: email_address, password: password }
  end
end
