require 'rails_helper'

describe Comment, type: :model do
  subject { create(:comment) }

  context "Associations" do
    it { should belong_to(:ticket) }
    it { should belong_to(:user) }
  end

  context "validations on creation" do
    context "valid attributes" do
      it "is valid with content and a ticket_id" do
        expect(subject).to be_valid
      end
    end

    context "invalid attributes" do
      context "content" do
        it "is invalid without content" do
          subject.content = nil
          expect(subject).to be_invalid
        end

        it "is invalid when content is over 9810 characters" do
          subject.content = ("a" * 9811)
          expect(subject).to be_invalid
        end
      end

      context "ticket_id" do
        it "is invalid without a ticket_id" do
          subject.ticket_id = nil
          expect(subject).to be_invalid
        end

        it "is invalid without an existing ticket_id" do
          subject.ticket_id = 2000 # Assuming that no role with id 2000 exists
          expect(subject).to be_invalid
        end
      end

      context "user_id" do
        it "is invalid without a user_id" do
          subject.user_id = nil
          expect(subject).to be_invalid
        end

        it "is invalid without an existing user_id" do
          subject.user_id = 2000 # Assuming that no role with id 2000 exists
          expect(subject).to be_invalid
        end
      end
    end
  end
end
