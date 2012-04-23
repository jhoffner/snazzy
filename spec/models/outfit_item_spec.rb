require 'spec_helper'

describe OutfitItem do
  let(:existing_dressing_room) { DressingRoom.first }
  let(:existing_outfit_item) { existing_dressing_room.outfits.first.items.first }
  let(:new_outfit_item) { existing_outfit_item.outfit.items.new }
  let(:valid_dressing_room) { Fabricate :dressing_room }
  let(:valid_outfit_item) { Fabricate(:outfit).items.first }

  describe "check test data" do
    it "should have valid existing and new instances" do
      existing_dressing_room.valid?.should be_true
      existing_outfit_item.valid?.should be_true
      valid_dressing_room.valid?.should be_true
      valid_outfit_item.valid?.should be_true
    end

    it "should have invalid new instance" do
      new_outfit_item.invalid?.should be_true
    end
  end

  describe "valid fields" do
   it "should fail if dressing_room_item is missing" do
     test_validates_presence_of new_outfit_item, :dressing_room_item_id, existing_outfit_item.dressing_room_item_id
   end
  end

  describe "dressing_room_item getter/setter" do
    it "should return the dressing room item reference when there is a id given" do
      existing_outfit_item.dressing_room_item.should_not be_nil
      existing_outfit_item.dressing_room_item.instance_of?(DressingRoomItem).should be_true
      existing_outfit_item.instance_eval("@dressing_room_item").should_not be_nil
    end

    it "should return nil when the dressing room item id is not given" do
      new_outfit_item.dressing_room_item.should be_nil
    end

    it "should also set dressing room item id attribute when dressing_room_item is set" do
      new_outfit_item.dressing_room_item.should be_nil
      new_outfit_item.dressing_room_item_id.should be_nil

      new_outfit_item.dressing_room_item = existing_outfit_item.dressing_room_item
      new_outfit_item.dressing_room_item.should_not be_nil
      new_outfit_item.dressing_room_item_id.should_not be_nil
    end
  end

end
