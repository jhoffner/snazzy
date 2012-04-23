class DressingRoom
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia
  include ModelMixins::UrlFriendly
  include ModelMixins::UserDependant

  include DressingRoom::CallbackHandlers
  include DressingRoom::Queries

  #### relationships:
  embeds_many :items, class_name: 'DressingRoomItem', inverse_of: :dressing_room
  has_many :outfits

  #### fields:
  field :tags,      type: String


  #### validations:

  validates_uniqueness_of :name, scope:[:username], case_sensitive: false

  #### indexes:

  index [[:username, Mongo::ASCENDING], [:name, Mongo::ASCENDING]], unique: true, sparse: true

end

class DressingRoomItem
  include Mongoid::Document
  include Mongoid::Paranoia
  include ModelMixins::WebLink

  #### relationships:

  embedded_in :dressing_room
end