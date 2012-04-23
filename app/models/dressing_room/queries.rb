class DressingRoom
  module Queries
    extend ActiveSupport::Concern

    def find_by_name(username, name)
      DressingRoom.where(username: username, name: name).first
    end
  end
end