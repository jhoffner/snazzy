class DressingRoom
  module Queries
    extend ActiveSupport::Concern

    included do

    end

    module ClassMethods
      def find_by_slug(username, slug)
        DressingRoom.where(username: username, slug: slug).first
      end
    end
  end
end