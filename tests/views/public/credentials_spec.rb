require './spec_helper'

describe "the sign in process" do

  subject { page }

  describe "password reset page" do
    before { visit 'public/credentials/new' }

    it { should have_selector("h2", text: "Password Reset") }
    it { should have_title("Password Reset") }
  end

  describe "enter email" do
    before { visit 'public/credentials/new' }

    describe "with invalid email" do
      before {click_button "Send Email"}

      it { should have_title("Password Reset") }
      it { should have_selector("div.alert.alert-warning", text: "enter your email address") }

    end

    describe "with valid email" do
      before do
        fill_in "email", with: "adam.p.chapman@gmail.com"
        click_button "Send Email"
      end

      it { should have_selector("div.alert.alert-success", text: "check your email") }

    end
  end

  describe "click back button" do
    before do
      visit 'public/credentials/new'
      click_link "Cancel"
    end

    it { should have_title("Sign in") }
  end

end
