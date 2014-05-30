require 'spec_helper'

describe Storytime.user_class do
  it "assigns the admin role to the first user created" do
    Storytime.user_class.count.should == 0
    user = Storytime.user_class.create(email: "tony@stark.com", password: "password", password_confirmation: "password")
    Storytime.user_class.count.should == 1
    user.should be_admin
  end
end