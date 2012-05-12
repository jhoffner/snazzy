require 'fastimage'

class PluginController < ApplicationController

  before_filter do |controller|
    controller.send(:authenticate_user!, controller: :plugin, action: :bar_sign_in) unless controller.action_name == "bar_sign_in"
  end

  def bar
    load_dressing_room_info
  end

  def rail
    load_dressing_room_info
  end

  def bar_sign_in
  end

  def install

  end

  def image_size
    render json: FastImage.size(params[:image_url])
  end

  private

  def load_dressing_room_info
    @rooms = user.dressing_rooms.order_by([:label, :asc]).to_a
    @default_room = user.recent_dressing_room
    @default_room = @rooms.first unless @default_room
  end



end
