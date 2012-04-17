require 'spec_helper'

describe User do
  let(:new_user) { User.new }
  let(:existing_user) {User.first}
  let :valid_user do
    User.new(
        first_name: "jane",
        last_name: "doe",
        email: "jane.doe@gmail.com",
        password: "password",
        username: "jane_doe",
        fb_uid: "testid"
    )
  end

  describe "valid fields" do
    it "fails without a user name" do

      #new user should be invalid because user name and first/last name fields are blank
      new_user.user_name.blank?.should be_true
      new_user.invalid?.should be_true

      new_user.errors.should have_key :username

      valid_user.user_name.blank?.should be_false
      valid_user.valid?.should be_true

      existing_user.valid?.should be_true
    end

    it "fails without first and last name fields" do
      new_user.first_name.should be_nil
      new_user.last_name.should be_nil

      new_user.invalid?.should be_true
      new_user.errors.should have_key :first_name
      new_user.errors.should have_key :last_name
    end

    it "fails without a valid email address" do
      new_user.email.should be_empty
      new_user.invalid?.should be_true
      new_user.errors.should have_key :email

      new_user.email = "invalid email"
      new_user.invalid?.should be_true
      new_user.errors.should have_key :email

      new_user.email = "valid@email.com"
      new_user.invalid?.should be_true
      new_user.errors.should_not have_key :email
    end

    it "fails without a valid gender unless gender is not specified" do
      new_user.gender.should be_nil
      new_user.invalid?.should be_true
      new_user.errors.should_not have_key :gender

      new_user.gender = 'x'
      new_user.invalid?.should be_true
      new_user.errors.should have_key :gender

      new_user.gender = 'f'
      new_user.invalid?.should be_true
      new_user.errors.should_not have_key :gender
    end
    #it "fails with a missing password unless a fb id is present" do
    #  new_user.password.should be_nil
    #  new_user.invalid?.should be_true
    #  new_user.errors.should have_key :password
    #
    #  new_user.fb_uid = "uid format is not currently validated so this should work"
    #  new_user.invalid?.should be_true
    #  new_user.errors.should_not have_key :password
    #end
  end
end
