class DressingRoomsController < ApplicationController
  # for now all actions in this controller should require authentication
  before_filter :authenticate_user!, :check_room_read_access

  expose :room do
    if params[:slug]
      presenter { DressingRoom.find_by_slug(params[:username], params[:slug]) }
    else
      nil
    end
  end

  expose :room_item do
    if params[:item_id] and room
      presenter {room.items.find(params[:item_id]) }
    else
      nil
    end
  end

  expose :room_item_activity do
    if params[:activity_id] and room_item
      presenter {room_item.activities.find(params[:activity_id]) }
    else
      nil
    end
  end

  def index
    @rooms = presenters {DressingRoom.where(user_id: session_user_id) }
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

  def show_item
    @room_item = presenter(:tile) {room.items.find(params[:item_id]) }

    render partial: 'dressing_rooms/tiles/room_item', locals: {
        item: presenter(:tile, room_item)
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

      room_item.prepare true
      room_item.save!
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
