class DressingRoomItem
  class TilePresenter < DressingRoomItem::Presenter

    def active_class_name
      if session_user_likes?
        "likes"
      elsif session_user_dislikes?
        "dislikes"
      else
        ""
      end
    end
  end
end