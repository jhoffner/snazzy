class DressingRoomItem
  module Prepare
    extend ActiveSupport::Concern

    def _prepare(options)
      options.defaults = {
          prepare_activity_counts: options[:prepare_defaults]
      }

      _prepare_activity_counts if options[:prepare_activity_counts]
    end

    def _prepare_activity_counts
      prepared.likes_count = activities.likes.count
      prepared.dislikes_count = activities.dislikes.count
      prepared.comments_count = activities.comments.count
    end

  end
end