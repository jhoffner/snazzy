class DressingRoom
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia
  include ModelMixins::Slug
  include ModelMixins::UserDependant

  include DressingRoom::CallbackHandlers
  include DressingRoom::Queries

  #### relationships:
  embeds_one :prepared, class_name: 'DressingRoomPrepared', inverse_of: :dressing_room
  embeds_many :items, class_name: 'DressingRoomItem', inverse_of: :dressing_room
  has_many :outfits

  #### fields:
  field :tags,      type: String


  #### validations:

  validates_uniqueness_of :slug, scope:[:user_id], case_sensitive: false

  #### indexes:

  index [[:user_id, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]], unique: true

end

class DressingRoomItem
  include Mongoid::Document
  include Mongoid::Paranoia
  include ModelMixins::WebLink

  #### relationships:

  embedded_in :dressing_room
end

class DressingRoomPrepared
  include Mongoid::Document

  embedded_in :dressing_room
  embeds_one :image, as: :image_owner

  #### fields:

  field :items_count,   type: Integer, default: 0

end
