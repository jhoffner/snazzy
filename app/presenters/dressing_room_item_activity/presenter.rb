class DressingRoomItemActivity
  class Presenter < ApplicationPresenter
     def label
        if is_vote?
          if user == session_user
            like? ? "like this" : "dislike this"
          else
            like? ? "likes this" : "dislikes this"
          end
        else
          ": #{message}"
        end
      end
  end
end