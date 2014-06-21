require './spec_helper'

describe "the sign in process" do

  subject { page }

  describe "signin page" do
    before { visit '/public/signin' }

    # page.current_path.should == '/public/signin'
    it { should have_selector("h3", text: "Sign in") }
    it { should have_title("Sign in") }
  end

  describe "signin" do
    before { visit '/public/signin' }

    describe "with invalid email & password" do
      before {click_button "Sign in"}

      it { should have_title("Sign in") }
      it { should have_selector("div.alert.alert-danger", text: "unsuccessful") }

      describe "after visiting another page" do
        before { click_link "Forgotten?" }
        # checks the flash danger message is not showing
        it { should_not have_selector("div.alert.alert-danger") }
      end

    end

    describe "with valid email & password" do
      before do
        fill_in "email", with: "adam.p.chapman@gmail.com"
        fill_in "password", with: "password*321"
        click_button "Sign in"
        find("div.navbar").find("span.glyphicon.glyphicon-cog").click
      end

      it { should have_title("Dashboard") }
      it { should have_link("Security") }
      it { should have_link("Sign out") }

      describe "followed by sign out" do
        before { click_link("Sign out") }
        it { should have_button("Sign in") }
      end

    end
  end
end
