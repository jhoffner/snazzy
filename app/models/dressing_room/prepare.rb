class DressingRoom
  module Prepare
    extend ActiveSupport::Concern

    protected
    def _prepare(options)
      options.defaults = {
          prepare_images: options[:prepare_default],
          prepare_latest_activities: options[:prepare_all]
      }

      _prepare_images if options[:prepare_images]
      _prepare_latest_activities if options[:prepare_latest_activities]

      self.prepared.items_size = items.size if items

    end

    def _prepare_latest_activities
      # TODO: prepare top latest activity items to show
    end

    def _prepare_images
      # prepare the image to be displayed as the room thumbnail. for now we are only
      # going to show the most recent one but eventually this may be extended into additional images or selective images
      main_image = nil
      thumb_images = []

      r_items = self.items.reverse.to_a

      # find latest best match for main picture
      r_items.each do |item|
        if item.image.width >= 170 and item.image.height < item.image.width * 1.34
          main_image = item.image
          break
        end
      end

      # if the most optimal image could not be found then try a more lenient criteria
      unless main_image
        r_items.each do |item|
          if item.image.width >= 150 and item.image.height > 80
            main_image = item.image
            break
          end
        end
      end

      # if the 2nd most optimal image could not be found then just use the latest image
      unless main_image
        main_image = r_items.first.image
      end

      r_items.each do |item|
        if item.image.width > 40
          thumb_images << item.image if main_image != item.image
          break if thumb_images.size > 3
        end
      end

      prepared.main_image = main_image
      prepared.thumb_images = thumb_images
    end
  end
end