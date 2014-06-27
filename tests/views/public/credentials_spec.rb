require './spec_helper'

describe "the sign in process" do

  subject { page }

  describe "password edit page" do
    before { visit 'public/credentials/edit?token=foo' }

    describe "get page" do
      it { should have_selector("h2", text: "Password Reset") }
      it { should have_title("Password Reset") }
    end

    describe "enter mismatched password and confirmation" do
      before do
        fill_in "person[password]", with: "foo"
        fill_in "person[passwordConfirmation]", with: "bar"
        click_button "Save"
      end

      it { should have_selector("div.alert.alert-danger", text: "error") }

    end

    describe "enter matching password and confirmation" do
      before do
        fill_in "person[password]", with: "password*321"
        fill_in "person[passwordConfirmation]", with: "password*321"
        click_button "Save"

        it { should have_selector("div.alert.alert-success", text: "password updated") }
        it { should have_title("Dashboard") }

      end
    end

  end

  describe "password reset page" do
    before { visit 'public/credentials/new' }

    describe "get page" do
      it { should have_selector("h2", text: "Password Reset") }
      it { should have_title("Password Reset") }
    end

    describe "click back button" do
      before { click_link "Cancel" }
      it { should have_title("Sign in") }
    end

    describe "enter email" do

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
  end

end
