#require 'spec_helper'
#
#describe Outfit do
#  let(:existing_user) { User.first }
#  let(:new_outfit) { existing_user.dressing_rooms.first.outfits.new }
#  let(:existing_dressing_room) { DressingRoom.first }
#  let(:existing_outfit) { existing_dressing_room.outfits.first }
#  let(:valid_user) { build_valid_user }
#  let(:valid_dressing_room) { valid_user.dressing_rooms.first }
#  let(:valid_outfit) { valid_dressing_room.outfits.first }
#
#  describe "check test data" do
#    it "should have correctly valid or invalid instances" do
#      existing_user.valid?.should be_true
#
#      new_outfit.invalid?.should be_true
#      existing_dressing_room.valid?.should be_true
#      existing_outfit.valid?.should be_true
#      valid_dressing_room.valid?.should be_true
#      valid_outfit.valid?.should be_true
#    end
#
#    describe "valid_outfit" do
#      it "should have dressing room set" do
#        valid_outfit.dressing_room.should_not be_nil
#      end
#
#      it "should be set as a sub-collection item on parent dressing room" do
#        valid_outfit.dressing_room.outfits.last == valid_outfit
#      end
#    end
#  end
#
#  describe "valid fields" do
#    it "should fail if slug/dressing_room_id pair is not unique" do
#      valid_outfit.dressing_room_id = existing_outfit.dressing_room_id
#      test_validates_uniqueness_of existing_outfit, valid_outfit, :slug
#    end
#  end
#
#  describe "dressing room field setters" do
#    #it "should set user field when dressing_rooms.new is called" do
#    #  existing_dressing_room.user #load the user
#    #  outfit = existing_dressing_room.outfits.new
#    #  outfit.instance_variable_get("@user").should_not be_nil
#    #end
#
#    it "should set user id field when dressing_rooms.new is called" do
#      new_outfit.user_id.should_not be_nil
#    end
#
#    it "should set username when dressing_rooms.new is called" do
#      new_outfit.username.blank?.should_not be_true
#    end
#
#    it "should set dressing_room_slug when dressing_rooms.new is called" do
#      new_outfit.dressing_room_slug.blank?.should_not be_true
#    end
#  end
#
#  describe "queries" do
#    it "should find outfit by username, dressing room slug and outfit slug" do
#      outfit = Outfit.find_by_slug(existing_outfit.username, existing_dressing_room.slug, existing_outfit.slug)
#      outfit.should_not be_nil
#    end
#  end
#end
