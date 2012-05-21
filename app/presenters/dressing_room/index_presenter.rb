class DressingRoom
  class IndexPresenter < DressingRoom::Presenter
    def main_image_url
      prepared.main_image["url"] if prepared.main_image
    end

    def thumb_images
      images = []
      4.times do |i|
        images.push (prepared.thumb_images and prepared.thumb_images.size > i) ? prepared.thumb_images[i] : nil
      end
      images
    end

  end
end