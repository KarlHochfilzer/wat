require 'spec_helper'

describe User do

  it "uses name as a key" do
    user = User.create!(name: 'Andi Altendorfer', email: 'andreas@altendorfer.at')
    assert User.find('andi-altendorfer') == user
  end

  it "doesn't allow two users having the same name" do
    user1 = User.create!(name: 'Andi Altendorfer', email: 'andreas@altendorfer.at')
    user2 = User.new(  name: 'Andi Altendorfer', email: 'andi@altendorfer.at')
    assert !user2.valid?(), 'User with same name should not be created'
  end

  it "removes identities when destroyed" do
    user = User.create!(name: "Test With Identities", email: 'identity@iboard.cc')
    identity = Identity.create!(provider: 'identity', uid:'test123', name: 'Test With Identities', password:"12345", password_confirmation: "12345")
    user.authentications = [ identity ]
    user.save!
    assert user.authentications.count == 1
    assert Identity.count == 1, "there should be one identity"
    user.destroy
    assert Identity.count == 0, "Identity should have been deleted"
  end

  it "should store geo-location" do
    user = User.create!(name: "Test User", email: 'user@iboard.cc')
    user.location_token = "48.2073,14.2542"
    user.save!
    user.reload
    assert user.location['lat'] == 48.2073,
      "User's latitude should be 48.2073 but is #{user.location.inspect}"
    assert user.location['lng'] == 14.2542
      "User's longitude should be 14.2542 but is #{user.location.inspect}"
  end

  describe "(standard user)" do
    before :each do
      User.delete_all
      @user = test_user "The Pirate", "ahoid"
    end

    it "sends a forgot password link" do
      user = User.where(email: 'the.pirate@example.com').first
      user.reset_password
      last_email.to.should include('the.pirate@example.com')
      last_email.parts.first.body.should  match /requeset to reset your password/
    end
  end

end
