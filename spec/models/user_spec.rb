require 'spec_helper'

describe User do

  it "uses name as a key" do
    user = User.create!(name: 'Andi Altendorfer', email: 'andreas@altendorfer.at')
    assert User.find('andi-altendorfer') == user
  end

  it "doesn't allow two users having the same name" do
    user1 = User.create!(name: 'Andi Altendorfer', email: 'andreas@altendorfer.at')
    user2 = User.new(  name: 'Andi Altendorfer', email: 'andi@altendorfer.at')
    assert !user2.valid?, 'User with same name should not be created'
  end
end
