require "rails_helper"

RSpec.feature "Guest redirects to home" do
  context "As an unauthenticated visitor" do
    before(:each) do
      visit root_path
    end

    describe "if I try to go to the dashboard page" do
      scenario "I am redirected to the login path" do
        visit dashboard_path    

        expect(current_path).to eq login_path
      end
    end
  end
end

