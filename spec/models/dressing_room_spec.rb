
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

    it "should not allow slugs with whitespace" do
      test_valid_value(new_room, :slug, 'slug_value')
      test_invalid_value(new_room, :slug, 'slug value')
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

  end

  describe "prepare module" do
    it "should create an empty prepared document when created" do
      new_room.prepared.should_not be_nil
    end

    it "should set the prepared.main_image field on prepare" do
      valid_room.prepared.main_image.should be_nil
      valid_room.prepare
      valid_room.prepared.main_image.should_not be_nil

      valid_room.reload
      valid_room.prepared.main_image.should_not be_nil
      valid_room.prepare

      valid_room.reload
      valid_room.prepared.main_image.should_not be_nil
      valid_room.prepare

      valid_room.reload
      valid_room.prepared.main_image.should_not be_nil
    end

    it "should set the prepared.thumb_images field on prepare" do
      valid_room.prepared.thumb_images.size.should == 0
      valid_room.prepare
      valid_room.prepared.thumb_images.should_not be_nil
      valid_room.prepared.thumb_images.empty?.should be_false

      valid_room.reload
      valid_room.prepared.thumb_images.size.should > 0
      valid_room.prepare

      valid_room.reload
      valid_room.prepared.thumb_images.size.should > 0
    end

    it "should be able to be prepared after an item is added" do
      existing_room.items.create!(url: "http://www.test.com", image: Fabricate.build(:image))
      existing_room.prepare
      existing_room.prepared.items_size.should == existing_room.items.size
    end

    it "should set the prepared items count on save" do
      valid_room.prepared.items_size.should == 0

      valid_room.items.size.should > 0

      valid_room.prepare
      valid_room.prepared.items_size.should == valid_room.items.size

      valid_room.reload
      valid_room.items.build url: "http://www.test.com", image: {url: "http://www.test.com/asdfasdf.png", width: 500, height: 500}
      valid_room.prepare
      valid_room.prepared.items_size.should == valid_room.items.size

    end

  end

  describe "valid dressing room item image field" do
    let(:valid_item) do
        valid_item = valid_room.items.first
        valid_item.created_at = Time.now.utc
        valid_item
    end

    let(:dup_item) do
      valid_room.items.new url: valid_item.url, created_at: Time.now.utc + 3.hours, image: valid_item.image.clone
    end

    describe "validate test data" do
      it "should have properly set fields" do
        valid_item.created_at.nil?.should be_false
        dup_item.created_at.nil?.should be_false
        valid_item.created_at.should < dup_item.created_at

        valid_item.image.url.blank?.should be_false
        valid_item.image.url.should == dup_item.image.url

        dup_item.dressing_room.items.select {|item| item.image.url == valid_item.image.url}.count.should == 2
      end

      it "dup_item.dup_image? should be true" do
        dup_item.dup_image?.should be_true
      end
    end

    it "should validate uniqueness of image.url field" do
      dup_item.invalid?.should be_true
      dup_item.errors.should have_key :"image.url"

      dup_item.image.url = "http://www.test.com/valid-url.png"

      dup_item.valid?.should be_true
    end

    it "should only show invalid errors for the duplicate image and not the original" do
      dup_item.invalid?.should be_true
      valid_item.valid?.should be_true
    end

    it "should not error when there are no duplicates" do
      dup_item.image.url = "http://www.test.com/uniqueurl.png"
      dup_item.valid?.should be_true
    end
  end
end
