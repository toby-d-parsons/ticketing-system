require 'rails_helper'

describe User do
  let!(:role) { Role.create(name: 'Admin') }

  subject do
    described_class.create(
      email_address: "testemail@email.com",
      password: "password",
      role_id: role.id
      )
  end

  describe "validations on creation" do
    context "when valid attributes are provided" do
      it "is valid with an email_address, password, and valid role_id" do
        expect(subject).to be_valid
      end
    end

    context "when invalid attributes are provided" do
      it "is invalid without a password" do
        subject.password = nil
        expect(subject).to be_invalid
      end

      it "is invalid without an email_address" do
        subject.email_address = nil
        expect(subject).to be_invalid
      end

      it "is invalid without a role_id" do
        subject.role_id = nil
        expect(subject).to be_invalid
      end

      it "is invalid without a valid role_id" do
        subject.role_id = 200 # Assuming that no role with id 200 exists
        expect(subject).to be_invalid
      end
    end
  end
end
