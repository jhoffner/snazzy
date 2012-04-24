module ModelMixins
  module DressingRoomDependant
    extend ActiveSupport::Concern

    included do

      #### relationships:
      belongs_to :dressing_room

      #### fields:

      field :dressing_room_slug,          type: String

      #### field overrides:
      wrap_method :dressing_room= do |value, wrapped|
        wrapped.call(value)
        if value
          self.dressing_room_slug = value.slug

          if self.is_a? ModelMixins::UserDependant
            self.username = value.username
            self.user_id = value.user_id
            #self.user = value.instance_variable_get('@user') # get the cached version only
          end
        end
      end

      #### validations:
      validates_presence_of :dressing_room_slug, :dressing_room_id

    end
  end
end