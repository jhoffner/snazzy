
class DressingRoom
  class Presenter < ApplicationPresenter
    def var_data
      data = model.slice(:username, :slug)
      data[:user_owned] = session_user ? session_user.id == model.user.id : false
      data
    end

    def render_room_item_tile(item)
      view_context.render partial: 'dressing_rooms/tiles/room_item', locals: {
          item: presenter(:tile, item)
      }
    end
  end
end