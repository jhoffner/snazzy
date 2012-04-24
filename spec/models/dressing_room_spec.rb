require 'spec_helper'

describe DressingRoom do

  let(:new_room) { DressingRoom.new }
  let(:existing_room) { DressingRoom.first }
  let(:valid_room) { build_valid_user.dressing_rooms.first }

  describe "check test data" do
    it "should have an existing room" do
      existing_room.should_not be_nil
    end

    it "should have existing items" do
      existing_room.items.size.should > 1
      valid_room.items.size.should > 1
    end

    it "should have existing outfits" do
      existing_room.outfits.size.should > 0
      #valid_room.outfits.size.should > 1
    end

    it "should have existing outfit items" do
      existing_room.outfits.first.items.size.should > 1
      #valid_room.outfits.first.items.size.should > 1
    end

    it "should have a valid room" do
      valid_room.valid?.should be_true
    end
  end

  describe "field setters" do
    it "should set slug when label setter is called" do
      new_room.label = 'this is a test'
      new_room.slug.should eq 'this-is-a-test'
    end

    it "should set slug when label is set through DressingRoom.new method" do
      item = DressingRoom.new(
         label: 'test name'
      )

      item.slug.should eq 'test-name'
    end

    it "should set slug when label is set through user.dressing_rooms.new method" do
      item = User.first.dressing_rooms.new(
          label: 'test name'
      )

      item.slug.should eq 'test-name'
    end

  end

  describe "valid fields" do
    it "should not allow two dressing rooms with the same slug for the same user" do
      user = User.first
      existing_room.user_id.should eq user.id
      new_room = user.dressing_rooms.new(
        label: existing_room.label
      )

      new_room.invalid?.should be_true
      new_room.errors.should have_key :slug

      # create a new user so we can associate that id which should cause the unique constraint to no longer fail
      new_user = User.new
      new_room.user_id = new_user.id

      new_room.valid?.should be_true
      new_room.errors.should_not have_key :slug
    end

    it "should create an empty prepared document when created" do
      new_room.prepared.should_not be_nil
    end

    it "should set the prepared.image field on save" do
      valid_room.prepared.image.should be_nil
      valid_room.save!
      valid_room.prepared.image.should_not be_nil
    end
  end
end
