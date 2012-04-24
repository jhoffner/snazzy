class DressingRoom
  module CallbackHandlers
    extend ActiveSupport::Concern

    included do
      after_initialize do
        self.prepared = DressingRoomPrepared.new
        self.prepared.dressing_room = self
      end

      before_save do

        # prepare the image to be displayed as the room thumbnail. for now we are only
        # going to show the most recent one but eventually this may be extended into additional images or selective images
        item = self.items.last
        self.prepared.image = item.image if item

        self.prepared.items_count = self.items.count
      end
    end
  end
end