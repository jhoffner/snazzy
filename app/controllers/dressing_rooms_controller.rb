class DressingRoomsController < ApplicationController
  # for now all actions in this controller should require authentication
  before_filter :authenticate_user!, :check_user_write_access

  def index
    @rooms = DressingRoom.where(user_id: session_user_id).to_a
      #.only(:slug, :label, :username, :prepared)

  end

  def show
  end

  def create

  end

  def destroy
  end

  def create_item
    render_json_success do |json|
      room = DressingRoom.find_by_slug(params[:username], params[:slug])

      item_data = params[:item]
      raise "missing required data" unless item_data
      #raise "Item already in collection" if room.items.any? {|item| item.image.url == item_data[:image][:url] and item.deleted_at.nil?}

      room.items.new(item_data.slice :url, :image)
      room.save!
    end
  end

  def destroy_item
    render_json_success do
      room = DressingRoom.find_by_slug(params[:username], params[:slug])
      room.items.find(params[:id]).delete
      room.save!
    end
  end
end
