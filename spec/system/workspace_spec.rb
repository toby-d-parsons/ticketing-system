require 'rails_helper'

describe "Workspace", type: :system do
  include AuthenticationHelpers, NavigationHelpers, UIHelpers

  context "as an agent" do
    let!(:user) { create(:user, role: Role.find_by(name: "Support Agent")) }

    describe "when visiting the workspace dashboard page" do
      it "displays the page successfully" do
        sign_in_as(user)
        go_to_workspace_dashboard
        expect(page).to have_selector("h1", text: "Dashboard", wait: 10)
      end
    end
  end

  context "unauthenticated" do
    describe "when visiting the workspace dashboard page" do
      it "redirects unauthenticated users away from the tickets page" do
        visit root_path
        click_and_expect(:link, "Dashboard", "/session/new")
      end
    end
  end
end
