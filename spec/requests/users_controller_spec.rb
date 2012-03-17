# -*- encoding : utf-8 -*-

require File::expand_path('../../spec_helper', __FILE__)
require 'capybara/rspec'

describe UsersController do
  
  before(:each) do
    User.delete_all
    Identity.delete_all
    sign_up_user name: 'Testuser', password: 'notsecret', email: 'test@iboard.cc'
    user = User.first
    user.email_confirmed_at =  Time.now
    user.facilities.create name: 'Admin', access: 'rwx'
    user.save!
  end
 
  it "should login user" do
     sign_in_user name: 'Testuser', password: 'notsecret'
     visit users_path
     page.click_link "You –> Edit"
     page.should have_content "Testuser"
  end

  it "should have add- and remove authentication buttons" do
    sign_in_user name: 'Testuser', password: 'notsecret'
    visit "/users/testuser"
    page.should have_link "Twitter"
    page.should have_link "Facebook"
    page.should have_link "Remove"
  end

  it "should have a delete-button" do
    sign_in_user name: 'Testuser', password: 'notsecret'
    visit users_path
    page.should have_link "Cancel Account" 
    visit "/users/testuser"
    page.should have_link "Cancel Account" 
  end

  it "should delete user" do
    sign_in_user name: 'Testuser', password: 'notsecret'
    visit users_path
    page.click_link "Cancel Account" 
    visit users_path
    page.should have_no_content "Testuser"
  end

  it "shows facilities in user-show view" do
    User.first.facilities.create name: 'Admin', access: 'rwx'
    sign_in_user name: 'Testuser', password: 'notsecret'
    visit user_path(User.first)
    page.should have_content "Facilities: Admin"
  end

  it "shows facilities in user-list" do
    User.first.facilities.find_or_create_by name: 'Admin', access: 'rwx'
    sign_in_user name: 'Testuser', password: 'notsecret'
    visit users_path
    page.should have_content "Facilities: Admin"
  end

  it "should not show foreign users unless current_user is admin" do
    visit signout_path
    User.create  name: 'Foreigner', email: 'alien@iboard.cc'
    sign_up_user name: 'Hacker', password: 'notsecret', email: 'hacked@iboard.cc'    
    visit users_path
    page.should_not have_content "Foreigner"
    page.should have_content "Access denied"
  end

  it "sends a confirmation mail when a user is created" do
    visit signout_path
    sign_up_user name: "Friendly User", password: 'notsecret', email: 'newuser@iboard.cc'
    last_email.to.should include('newuser@iboard.cc')
  end

  it "sends a confirmation mail when the email changes" do
    visit signout_path
    sign_up_user name: "Friendly User", password: 'notsecret', email: 'user@iboard.cc'
    click_link "Edit"
    fill_in "Email", with: "user1@iboard.cc"
    click_button "Save"
    last_email.to.should include('user1@iboard.cc')
  end

  it "checks email confirmed" do
    visit signout_path
    User.delete_all
    sign_up_user name: "Friendly User", password: 'notsecret', email: 'user@iboard.cc'
    user = User.first
    assert user.email_confirmed? == false, "email_confirmed? should be false"
    visit confirm_email_user_path(user,user.confirm_email_token)
    user.reload
    assert user.email_confirmed? == true, "email_confirmed? should be true after confirming it"
  end

  it "shows a message if user doesn't confirm their email yet" do
    visit signout_path
    User.delete_all
    sign_up_user name: "Friendly User", password: 'notsecret', email: 'user@iboard.cc'
    visit signout_path
    sign_in_user name: "Friendly User", password: 'notsecret'
    page.should have_content "Your email isn't confirmed yet. Please check your mailbox for user@iboard.cc."
  end

end
