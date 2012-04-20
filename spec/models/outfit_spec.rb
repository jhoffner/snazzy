require 'spec_helper'

describe Outfit do
  let(:existing_user) { User.first }
  let(:new_outfit) { existing_user.dressing_rooms.first.outfits.new }
  let(:existing_dressing_room) { DressingRoom.first }
  let(:existing_outfit) { existing_dressing_room.outfits.first }
  let(:valid_dressing_room) { Fabricate :dressing_room }
  let(:valid_outfit) { valid_dressing_room.outfits.first }

  describe "check test data" do
    it "should have correctly valid or invalid instances" do
      existing_user.valid?.should be_true
      valid_user.valid?.should be_true
      new_outfit.invalid?.should be_true
      existing_dressing_room.valid?.should be_true
      existing_outfit.valid?.should be_true
      valid_outfit.valid?.should be_true
    end
  end

  describe "valid fields" do
    it "should fail if name is not unique" do
      test_validate_uniqueness_of existing_outfit, new_outfit, :name
    end
  end
end
