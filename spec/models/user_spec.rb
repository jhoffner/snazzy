require 'spec_helper'

describe User do
  let(:new_user) { User.new }
  let(:existing_user) { User.first }
  let(:valid_user) { Fabricate :user }

  valid_email = "valid@email.com"

  describe "field validations" do
    it "fails without a user name" do
      test_validates_presence_of(new_user, :username, "unique_user_name")
    end

    it "fails without a unique username" do
      test_validates_uniqueness_of(existing_user, valid_user, :username)
    end

    it "fails without first and last name fields" do
      test_validates_presence_of(new_user, :first_name, "first")
      test_validates_presence_of(new_user, :last_name, "last")
    end

    it "fails without a email address" do
      test_validates_presence_of(new_user, :email, valid_email)
    end

    it "fails without a valid formatted email address" do
      test_validates_format_of(new_user, :email, "invalid email", valid_email)
    end

    it "fails without a unique email address" do
      test_validates_uniqueness_of(existing_user, valid_user, :email)
    end

    it "fails without a unique fb uid" do
      test_validates_uniqueness_of(existing_user, valid_user, :fb_uid)
    end

    it "fails without a valid gender unless gender is not specified" do
      test_validates_inclusion_of(new_user, :gender, ['x'], [nil, 'm', 'f'])
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
