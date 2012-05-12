class DressingRoom
  module Prepare
    extend ActiveSupport::Concern

    protected
    def _prepare

      # prepare the image to be displayed as the room thumbnail. for now we are only
      # going to show the most recent one but eventually this may be extended into additional images or selective images
      item = items.last
      if item
        #mongoid seems to be touchy (really touchy) about setting embedded reference values when the value hasnt actually changed
        self.prepared.image = item.image.dup unless prepared.image and prepared.image.id == item.image.id
      end

      self.prepared.items_size = items.size if items

    end
  end
end