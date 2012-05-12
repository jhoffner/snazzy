class DressingRoomItem
  class Presenter < ApplicationPresenter
    #def activities
    #  @activities ||= presenters :default, model.activities.all
    #end

    def session_user_likes?
      @session_user_likes = model.activities.user(session_user).likes.any?
    end

    def session_user_dislikes?
      @session_user_dislikes = model.activities.user(session_user).dislikes.any?
    end
  end
end