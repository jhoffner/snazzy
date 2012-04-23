class Outfit
  module Queries
    extend ActiveSupport::Concern

    module ClassMethods
      def find_by_name(username, dressing_room_name, name)
        Outfit.where(
          username: username,
          dressing_room_name: dressing_room_name,
          name: name
        ).first
      end
    end
  end
end