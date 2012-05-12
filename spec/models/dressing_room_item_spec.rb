require 'spec_helper'

describe DressingRoomItem do
  let(:new_room) { DressingRoom.new }
  let(:existing_room) { DressingRoom.first }
  let(:valid_room) { build_valid_user.dressing_rooms.first }

  let(:existing_item) {existing_room.items.first}
  let(:valid_item) {valid_room.items.build(url: "http://www.test.com", image: Fabricate.build(:image))}

  let(:existing_comment) {existing_item.activities.first}
  let(:existing_like) {existing_item.activities.last }
  let(:valid_like) { valid_item.activities.likes.build user: valid_room.user }

  describe "check test data" do
    it "should have an existing objects" do
      existing_room.should_not be_nil
      existing_item.should_not be_nil
      existing_item.activities.size.should == 2

      existing_comment.should_not be_nil
      existing_comment.type.should == DressingRoomItemActivity::TYPE_COMMENT
      existing_like.should_not be_nil
      existing_like.type.should == DressingRoomItemActivity::TYPE_LIKE

    end

    it "should have valid room and item" do
      valid_room.valid?.should be_true
      valid_item.valid?.should be_true
      valid_like.valid?.should be_true
    end
  end

  describe "creating new activities" do
    describe "activity validations" do
      it "should prevent multiple votes from the same user" do
        existing_item.activities.size.should == 2
        activity = existing_item.activities.dislikes.build user: existing_room.user
        activity.user_id.should_not be_nil
        activity.invalid?.should be_true
        activity.errors.should have_key :type
      end

      it "should fail validation if a comment is missing a message value" do

        #count = existing_item.activities.count
        comment = existing_item.activities.build user: existing_room.user

        test_validates_presence_of comment, :message, 'valid value'

        #existing_item.activities.count.should == count + 1

        #should not be invalid for non-comment types
        valid_like.message = nil
        valid_like.valid?.should be_true

      end
    end



  end
end