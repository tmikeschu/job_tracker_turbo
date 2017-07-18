require "rails_helper"

RSpec.feature "User logout" do
  describe "A logged in user" do
    let(:user) { create(:user, password: "secret") }

    scenario "can log out" do
      visit login_path

      fill_in "Email", with: user.email
      fill_in "Password", with: "secret"
      click_on "Log in"

      click_on "Log out"

      expect(current_path).to eq root_path
      expect(page).to have_link "Login", href: login_path
      expect(page).to have_link "Create an account", href: new_user_path
    end
  end
end

