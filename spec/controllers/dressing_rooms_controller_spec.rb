require 'spec_helper'

describe DressingRoomsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "POST create" do
    it "returns http success" do

      get 'create', {username: existing_user.username, slug: existing_user.dressing_rooms.first.slug, label: "test create label"}, valid_session
      response.should be_success
    end
  end

  describe "PUT empty_items" do
    let :room do
      existing_user.dressing_rooms.first
    end

    it "returns success" do
      put 'empty_items', {username: existing_user.username, slug: room.slug}, valid_session
      response.should be_success
    end

    it "results in all items being deleted" do

      room.items.size.should > 0
      #room.items.deleted.size.should == 0

      put 'empty_items', {username: existing_user.username, slug: room.slug}, valid_session

      room.reload
      #room.items.deleted.size.should == room.items.size
      room.items.size.should == 0
    end

  end
end
