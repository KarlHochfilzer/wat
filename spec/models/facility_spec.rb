require 'spec_helper'

describe Facility do

  it "defines class Facility for User" do
    user = test_user 'Testuser', 'secret', ['Admin']
    assert user.can_read?('Admin'), 'can_read? should be true'
    assert user.can_write?('Admin'), 'can_write? should be true'
    assert user.can_execute?('Admin'), 'can_execute? should be true'

    assert !user.can_execute?('God'), 'Nobody should be execute as god!'
  end

  it "must have a name" do
    user = User.find_or_create_by(name: 'Testuser', email: 'test@iboard.cc')
    user.facilities.create(name: '', access: 'rwx')
    assert !user.valid?, 'User should not save with invalid facility'
  end

  it "checks one facility at a time" do
    user = User.find_or_create_by(name: 'Testuser', email: 'test@iboard.cc')
    user.email_confirmed_at = Time.now
    user.facilities.create(name: 'one', access: 'rwx')
    user.can_read?('one').should == true
    user.can_write?('one').should == true
    user.can_execute?('one').should == true
    user.can_read?('two').should == false
    user.can_write?('two').should == false
    user.can_execute?('two').should == false
  end

  it "checks more facilities at once" do
    user = User.find_or_create_by(name: 'Testuser', email: 'test@iboard.cc')
    user.email_confirmed_at = Time.now
    user.facilities.create(name: 'F1', access: 'rwx')
    user.facilities.create(name: 'F2', access: 'rwx')
    user.can_read?('F1','F2').should == true
    user.can_write?('F1','F2').should == true
    user.can_execute?('F1','F2').should == true
    user.can_read?('x1','x2').should == false
    user.can_write?('x1','x2').should == false
    user.can_execute?('x1','x2').should == false
  end

end