require "rails_helper"

RSpec.feature "User redirect from root path" do
  context "As a logged in user" do
    let(:user) { create(:user) }
    before(:each) do
      stub_login_for(user)
      visit dashboard_path
    end

    describe "if I visit the root path" do
      scenario "I am redirected to my dashboard" do
        within "nav h1" do
          click_on "Job Tracker"
          expect(current_path).to eq dashboard_path
        end
      end
    end
  end
end

