class DressingRoom
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia
  include ModelMixins::Slug
  include ModelMixins::UserDependant

  include DressingRoom::CallbackHandlers
  include DressingRoom::Queries

  #### consts:

  PRIVACY_PUBLIC = 'p'
  PRIVACY_FRIENDS_ONLY = "fo"
  PRIVACY_ME_ONLY = 'mo'

  #### relationships:
  embeds_one :prepared, class_name: 'DressingRoomPrepared', inverse_of: :dressing_room
  embeds_many :items, class_name: 'DressingRoomItem', inverse_of: :dressing_room, cascade_callbacks: true
  has_many :outfits

  #### fields:
  field :tags,      type: String
  field :privacy,   type: String, default: PRIVACY_ME_ONLY


  #### validations:

  validates_uniqueness_of :slug, scope:[:user_id], case_sensitive: false
  validates_exclusion_of  :slug,
                          # need to prevent these values since they are used in the url routing structure
                          in: %w{api settings},
                          message: 'is a reserved name'

  #### indexes:

  index [[:user_id, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]], unique: true

end

class DressingRoomItem
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps::Created
  include ModelMixins::WebLink

  #### relationships:

  embedded_in :dressing_room

  #### fields:


  #### validations:

  validate                :validate_uniqueness_of_new_image_url


  #### instance methods
  def dup_image?
    self.new? and self.image and dressing_room.items.any? {|item| item.deleted_at.nil? && item.image && item.image.url == self.image.url && item.id != self.id}
  end

  private

  # NOTE: if i decide to make the error message more useful on the parent then I should implement a solution similar to this one: http://stackoverflow.com/questions/5501396/rails-mongoid-error-messages-in-nested-attributes
  # NOTE: this only checks for new records. existing records are not checked once they are saved
  def validate_uniqueness_of_new_image_url
    self.errors[:"image.url"] = 'Image url has already been added to this collection' if self.dup_image?
  end
end

class DressingRoomPrepared
  include Mongoid::Document

  embedded_in :dressing_room
  embeds_one :image, as: :image_owner

  #### fields:

  field :items_count,   type: Integer, default: 0

end
