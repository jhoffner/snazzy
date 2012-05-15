class DressingRoomsController < ApplicationController
  # for now all actions in this controller should require authentication
  before_filter :authenticate_user!, :check_room_read_access

  #expose :room_model do
  #  if params[:slug]
  #    DressingRoom.find_by_slug(params[:username], params[:slug])
  #  else
  #    nil
  #  end
  #end

  expose_presenter :room do
    DressingRoom.find_by_slug(params[:username], params[:slug]) if params[:slug]
  end

  expose_presenter :room_item do
    room.items.find(params[:item_id]) if params[:item_id] and room
  end

  expose_presenter :room_item_activity do
    room_item.activities.find(params[:activity_id]) if params[:activity_id] and room_item
  end

  expose_presenters :rooms do
    DressingRoom.where(user_id: session_user_id)
  end

  def index
    # initialize the rooms presenters with the index type
    rooms(:index)
      #.only(:slug, :label, :username, :prepared)
  end

  def show
  end

  def create
    render_json_success do |json|
      check_room_write_access(true)

      item_data = params[:item]

      room = session_user.dressing_rooms.create(item_data.slice :label)

      if params[:set_recent]
        session_user.set(:recent_dressing_room_id, room.id)
      end
    end
  end


  def destroy
    render_json_success do
      check_room_write_access(true)
      room.delete!
    end
  end

  def show_dev
    authenticate_admin!
  end

  def prepare_dressing_rooms
    if authenticate_admin!
      session_user.dressing_rooms.invoke :prepare, prepare_all: true
      redirect_to dev_dressing_room_path(params[:username])
    end
  end

  def prepare_dressing_room
    if authenticate_admin!
      room.prepare prepare_all: true
      render inline: "Success"
    end
  end

  def show_item
    render partial: 'dressing_rooms/tiles/room_item', locals: {
        item: room_item(:tile)
    }
  end


  def create_item
    render_json_success do |json|
      check_room_write_access(true)

      item_data = params[:item]
      raise "missing required data" unless item_data
      #raise "Item already in collection" if room.items.any? {|item| item.image.url == item_data[:image][:url] and item.deleted_at.nil?}

      room.items.create!(item_data.slice :url, :image)
      room.prepare

      json[:item_id] = room.items.last.id.to_s
    end
  end

  def destroy_item
    render_json_success do
      room_item.delete
      room.prepare
    end
  end

  def empty_items
    render_json_success do
      check_room_write_access(true)

      room.items.delete_all
      room.prepare
    end
  end

  def create_item_comment
    create_item_activity :build_comment
  end

  def create_item_like
    create_item_activity :build_like
  end

  def create_item_dislike
    create_item_activity :build_dislike
  end

  def create_item_activity(scope)
    render_json_success do
      check_room_write_access(true)
      existing = room_item.activities.user(session_user).votes.first

      activity = room_item.activities.send scope, params[:activity] || {}
      activity.user = session_user

      existing.delete if existing and activity.is_vote? and existing.type != activity.type

      room_item.save!

      room_item.prepare
    end
  end

  def delete_item_like
    params[:activity_id] = room_item.activities.user(session_user).likes.first.id
    destroy_item_activity
  end

  def delete_item_dislike
    params[:activity_id] = room_item.activities.user(session_user).dislikes.first.id
    destroy_item_activity
  end



  def destroy_item_activity
    render_json_success do
      check_room_write_access(true)

      room_item_activity.delete
      room_item.prepare
    end
  end



  private

  def check_room_read_access(raise_exception = false)
    check_user_read_access(raise_exception)
  end

  # placeholder for when more complicated room privileges are implemented
  def check_room_write_access(raise_exception = false)
    check_user_write_access(raise_exception)
  end
end
