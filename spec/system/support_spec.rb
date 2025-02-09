require 'rails_helper'

describe "Support", type: :system do
  context "when visiting the support home page" do
    it "displays the support home page successfully" do
      visit support_home_path

      expect(page).to have_selector("h1", text: "Home", wait: 10)
    end

    # Future improvements:
    # - Define which elements are visible and accessible based on RBAC
    # - Ensure users with different roles see correct content
  end
end
