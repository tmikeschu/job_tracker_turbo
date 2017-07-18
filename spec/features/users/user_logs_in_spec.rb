require "rails_helper"

RSpec.feature "User login" do
  describe "A registered user" do
    scenario "can log in" do
      user = create(:user, email: "test@test.test", password: "secret")
      visit root_path
      click_on "Login"

      expect(current_path).to eq login_path

      fill_in "Email", with: user.email
      fill_in "Password", with: "secret"
      click_on "Log in"
      expect(current_path).to eq dashboard_path
      expect(page).to have_content "Hello, #{user.username}!"
      expect(page).to_not have_link "Log in", href: login_path
      expect(page).to_not have_link "Create an account", href: new_user_path
    end
  end

  describe "Sad paths" do
    before(:each) do
      visit login_path
    end

    let!(:user) { create(:user, username: "tester", email: "test@test.test") }

    context "When the email is not in proper format" do
      scenario "the user sees an error", js: true do
        fill_in "Email", with: "test.com"
        fill_in "Password", with: "secret"
        click_on "Log in"

        email_error = page.find("#email").native.attribute("validationMessage")
        expect(email_error).to eq "Please include an '@' in the email address. 'test.com' is missing an '@'."
      end
    end

    context "When the email is incorrect" do
      scenario "the user sees an error" do
        fill_in "Email", with: "test@test.com"
        fill_in "Password", with: "secret"
        click_on "Log in"

        expect(page).to have_content "Invalid email"
      end
    end

    context "When the password is incorrect" do
      scenario "the user sees an error" do
        fill_in "Email", with: "test@test.test"
        fill_in "Password", with: "secretz"
        click_on "Log in"

        expect(page).to have_content "Invalid password"
      end
    end

    context "If data is missing" do
      scenario "the user sees errors", js: true do
        fields = { email: "test@test.test", password: "secret" }
        click_on "Log in"

        fields.each do |field, value|
          error = page.find("##{field}").native.attribute("validationMessage")
          expect(error).to eq "Please fill out this field."
          fill_in field.to_s.capitalize, with: value
          click_on "Log in"
        end
      end
    end
  end
end
