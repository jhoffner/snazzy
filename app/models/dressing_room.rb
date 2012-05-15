class DressingRoom
  include ModelMixins::RootDocument
  include ModelMixins::Slug
  include ModelMixins::UserDependant
  include ModelMixins::Prepared

  include Mongoid::Paranoia

  include DressingRoom::Commands
  include DressingRoom::Prepare
  include DressingRoom::CallbackHandlers
  include DressingRoom::Queries

  #### consts:

  PRIVACY_PUBLIC = 'p'
  PRIVACY_FRIENDS_ONLY = "fo"
  PRIVACY_ME_ONLY = 'mo'

  #### relationships:
  #embeds_one :prepared, class_name: 'DressingRoomPrepared', inverse_of: :dressing_room
  embeds_many :items, class_name: 'DressingRoomItem', inverse_of: :dressing_room, cascade_callbacks: true
  has_many :outfits

  #### fields:
  field :tags,      type: String
  field :privacy,   type: String, default: PRIVACY_ME_ONLY


  #### validations:

  validates_uniqueness_of :slug, scope:[:user_id], case_sensitive: false
  validates_exclusion_of  :slug,
                          # need to prevent these values since they are used in the url routing structure
                          in: %w{api settings item},
                          message: 'is a reserved name'

  #### indexes:

  index [[:user_id, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]], unique: true

end

class DressingRoomPrepared
  include ModelMixins::PreparedDocument

  embeds_one :main_image, class_name: "Image", as: :owner#, inverse_of: :image_owner, validate: false
  embeds_many :thumb_images, class_name: "Image", as: :owner#, inverse_of: :image_owner, validate: false
  embeds_many :latest_activities, class_name: "DressingRoomItemActivity"

  #### fields:

  field :items_size,   type: Integer, default: 0

  #### methdos:
  def add_latest_activity(activity)
    # todo: used for adding single activity items inline instead of through the full prepare_activity method
  end
end

