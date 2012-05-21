require 'spec_helper'

describe User do
  let(:new_user) { User.new }
  let(:existing_user) { User.first }
  let(:valid_user) { Fabricate.build :user }

  valid_email = "valid@email.com"

  describe "field validations" do
    it "fails without a user name" do
      test_validates_presence_of(new_user, :username, "unique_user_name")
    end

    it "fails without a unique username" do
      test_validates_uniqueness_of(existing_user, valid_user, :username)
    end

    it "fails with a reserved username" do
      test_validates_inclusion_of(new_user, :username, %w{plugin search about assets}, %w{valid_name})
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

  describe "helper methods" do
    it "should show correct display name" do
      valid_user.full_name.should == "#{valid_user.first_name} #{valid_user.last_name}"
      valid_user.first_name = ""
      valid_user.full_name.should == valid_user.last_name
    end
  end

  describe "DAO commands" do

    describe "add_friend" do
      it "should add friend id to both users" do
        valid_user.save!
        existing_user.add_friend(valid_user)
        existing_user.stale?.should be_true
        existing_user.reload
        valid_user.reload

        existing_user.friend_ids.include?(valid_user.id).should be_true
        valid_user.friend_ids.include?(existing_user.id).should be_true
      end

      it "should not add friend id if it is already added" do
        valid_user.save!
        existing_user.add_friend(valid_user)
        existing_user.reload
        existing_user.add_friend(valid_user)
        existing_user.reload
        existing_user.friends.size.should == 1
      end
    end

  end

  describe "facebook integration" do

    before do
      new_user.fb_profile = {
        "username" => 'fbusername',
        "first_name" => 'fb_first',
        "last_name" => 'fb_last',
        "birthday" => '05/08/1980',
        "id" => 'fbprofiletestid',
        "email" => 'test@facebook.com'
      }

      User.stub(:new).and_return(new_user)
    end

    let(:fb_user) { User.create_from_facebook('fakeaccesstoken') }

    it "should be able to create a new user from the profile" do
      fb_user.new?.should_not be_true
    end

    it "should create default dressing rooms" do
      fb_user.dressing_rooms.where(label: 'Wish List').exists?.should be_true
      fb_user.dressing_rooms.where(label: 'My Closet').exists?.should be_true
    end

    it "should set the recent_dressing_room to wish list for a new user" do
      fb_user.recent_dressing_room.should_not be_nil
      fb_user.recent_dressing_room_id.should_not be_nil
    end
  end
end
