class Outfit
  module Queries
    extend ActiveSupport::Concern

    module ClassMethods
      def find_by_slug(username, dressing_room_slug, slug)
        Outfit.where(
          username: username,
          dressing_room_slug: dressing_room_slug,
          slug: slug
        ).first
      end
    end
  end
end