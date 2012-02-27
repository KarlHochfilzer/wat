require 'spec_helper'

describe Authentication do

  it "is embeded to a user" do
    user = User.create!(name: 'Andi Altendorfer', email: 'andreas@altendorfer.at')
    user.add_authentication(Authentication.new(provider: 'test', uid: '123'))
    user.save!
    assert User.find_with_authentication('test','123') == user
  end

  it "doesn't allow two users having the same name" do
    user1 = User.create!(name: 'Andi Altendorfer', email: 'andreas@altendorfer.at')
    user2 = User.new(  name: 'Andi Altendorfer', email: 'andi@altendorfer.at')
    assert !user2.valid?, 'User with same name should not be created'
  end
end
