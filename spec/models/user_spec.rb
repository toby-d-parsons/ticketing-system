require 'rails_helper'

describe User, type: :model do
  let(:role) { Role.create(name: 'Admin') }

  subject do
    described_class.create(
      email_address: "testemail@email.com",
      password: "passworD12£$",
      role_id: role.id
      )
  end

  context "validations on creation" do
    context "valid attributes" do
      it "is valid with an email_address, password, and valid role_id" do
        expect(subject).to be_valid
      end
    end

    context "invalid attributes" do
      context "email address" do
        it "is invalid without an email_address" do
          subject.email_address = nil
          expect(subject).to be_invalid
        end

        it "is invalid without a username" do
          subject.email_address = "@gmail.com"
          expect(subject).to be_invalid
        end

        it "is invalid without a mail server and domain" do
          subject.email_address = "test@"
          expect(subject).to be_invalid
        end

        it "is invalid without an @ symbol" do
          subject.email_address = "testgmail.com"
          expect(subject).to be_invalid
        end

        it "is invalid when a duplicate email_address is entered" do
          described_class.create(
            email_address: "duplicate@test.com",
            password: "passworD12£$",
            role_id: role.id
          )
          subject.email_address = "duplicate@test.com"
          expect(subject).to be_invalid
        end
      end

      context "password" do
        it "is invalid without a password" do
          subject.password = nil
          expect(subject).to be_invalid
        end

        it "is invalid with less than 8 characters" do
          subject.password = "Test1!"
          expect(subject).to be_invalid
        end

        it "is invalid without lowercase letters" do
          subject.password = "TESTING!1"
          expect(subject).to be_invalid
        end

        it "is invalid without uppercase letters" do
          subject.password = "testing!1"
          expect(subject).to be_invalid
        end

        it "is invalid without symbols" do
          subject.password = "Testing1"
          expect(subject).to be_invalid
        end

        it "is invalid without numbers" do
          subject.password = "Testiiing!"
          expect(subject).to be_invalid
        end
      end

      context "role_id" do
        it "is invalid without a role_id" do
          subject.role_id = nil
          expect(subject).to be_invalid
        end

        it "is invalid with an invalid role_id" do
          subject.role_id = 200 # Assuming that no role with id 200 exists
          expect(subject).to be_invalid
        end
      end
    end
  end
end
