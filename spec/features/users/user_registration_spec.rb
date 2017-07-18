require "rails_helper"

RSpec.feature "User registration" do
  describe "A visitor" do
    scenario "can create an account" do
      visit root_path
      expect(page).to have_link "Log in", href: login_path
      click_on "Create an account"

      expect(current_path).to eq new_user_path

      fill_in "Username", with: "tester"
      fill_in "Email", with: "test@test.test"
      fill_in "Password", with: "supersecret"
      fill_in "Password confirmation", with: "supersecret"
      click_on "Submit"

      expect(current_path).to eq dashboard_path
      expect(page).to have_content "Hello, tester!"
      expect(page).to_not have_link "Create an account", href: new_user_path
      expect(page).to_not have_link "Log in", href: login_path
    end
  end

  describe "Sad paths" do
    before(:each) do
      visit new_user_path
    end

    context "When a username already exists" do
      scenario "another user cannot use the same username" do
        create(:user, username: "tester")

        fill_in "Username", with: "tester"
        fill_in "Email", with: "test@test.test"
        fill_in "Password", with: "supersecret"
        fill_in "Password confirmation", with: "supersecret"
        click_on "Submit"

        expect(page).to have_content "Username has already been taken"
      end
    end

    context "When an email already exists" do
      scenario "another user cannot use the same email" do
        create(:user, email: "test@test.test")

        fill_in "Username", with: "tester"
        fill_in "Email", with: "test@test.test"
        fill_in "Password", with: "supersecret"
        fill_in "Password confirmation", with: "supersecret"
        click_on "Submit"

        expect(page).to have_content "Email has already been taken"
      end
    end

    context "When data is not entered" do
      scenario "the user sees errors", js: true do
        click_on "Submit"

        fields = {
          username: "tester",
          email: "test@test.test",
          password: "secret",
          password_confirmation: "secret"
        }

        fields.each do |field, value|
          id = "#user_#{field}"
          error = page.find(id).native.attribute("validationMessage")
          expect(error).to eq "Please fill out this field."
          fill_in field.to_s.capitalize.tr("_", " "), with: value
          click_on "Submit"
        end
      end
    end

    context "When passwords do not match" do
      scenario "the user sees an error" do
        fill_in "Username", with: "tester"
        fill_in "Email", with: "test@test.test"
        fill_in "Password", with: "supersecret"
        fill_in "Password confirmation", with: "super"
        click_on "Submit"

        expect(page).to have_content "Password confirmation doesn't match"
      end
    end

    context "When the email is not in proper format" do
      scenario "the user sees an error", js: true do
        fill_in "Username", with: "tester"
        fill_in "Email", with: "test.com"
        fill_in "Password", with: "secret"
        fill_in "Password confirmation", with: "secret"
        click_on "Submit"

        email_error = page.find("#user_email").native.attribute("validationMessage")
        expect(email_error).to eq "Please include an '@' in the email address. 'test.com' is missing an '@'."
      end
    end
  end
end

