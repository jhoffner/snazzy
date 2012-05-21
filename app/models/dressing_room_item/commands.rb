class DressingRoomItem
  module Commands
    extend ActiveSupport::Concern

    def create_activity(type_name, user, attributes = {})
      existing = activities.user(user).votes.first

      activity = activities.send "build_#{type_name}", attributes || {}
      activity.user = user

      existing.delete if existing and activity.is_vote? and existing.type != activity.type

      prepare(save: false)

      save!
    end
  end
end