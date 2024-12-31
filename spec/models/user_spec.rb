require 'rails_helper'

describe User do
  let!(:role) { Role.create(name: 'Admin') }

  subject do
    described_class.create(
      email_address: "testemail@email.com",
      password: "passworD12£$",
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

      it "is invalid without a valid email_address (missing username)" do
        subject.email_address = "@gmail.com"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid email_address (missing mail server and domain)" do
        subject.email_address = "test@"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid email_address (missing symbol)" do
        subject.email_address = "testgmail.com"
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

      it "is invalid when duplicate email_address is entered" do
        described_class.create(
          email_address: "duplicate@test.com",
          password: "passworD12£$",
          role_id: role.id
        )
        subject.email_address = "duplicate@test.com"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid password" do
        subject.password = "test"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid password (< 8 characters)" do
        subject.password = "Test1!"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid password (No lowercase letters)" do
        subject.password = "TESTING!1"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid password (No uppercase letters)" do
        subject.password = "testing!1"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid password (No symbols)" do
        subject.password = "Testing1"
        expect(subject).to be_invalid
      end

      it "is invalid without a valid password (No numbers)" do
        subject.password = "Testiiing!"
        expect(subject).to be_invalid
      end
    end
  end
end
