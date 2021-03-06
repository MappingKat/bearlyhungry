require './spec/spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe "User Mail" do
  xit "should send welcoming email" do
    visit root_path
    first(:link, "Login").click
     within('#exampleModal') do
      click_on "Signup"
      fill_in "full-name",             :with => "Pho King"
      fill_in "display_name",          :with => "Phoking"
      fill_in "email-address",         :with => "phoking@sob.com"
      fill_in "password",              :with => "password"
      fill_in "password-confirmation", :with => "password"
    end
    click_on "Signup!"

    email = ActionMailer::Base.deliveries.last
    expect(email.subject).to eq "Welcome to Bearly Hungry"
  end
end
