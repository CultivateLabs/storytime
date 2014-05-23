require 'spec_helper'

describe Storytime::User do
  it "assigns the admin role to the first user created" do
    Storytime::User.count.should == 0
    user = Storytime::User.create(email: "tony@stark.com", password: "password", password_confirmation: "password")
    Storytime::User.count.should == 1
    user.should be_admin
  end
end