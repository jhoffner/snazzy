class DressingRoom
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia
  include DocumentComponents::FriendlyUrlName

  #### relationships:

  belongs_to :user

  embeds_many :outfits
  embeds_many :items, class_name: 'DressingRoomItem', inverse_of: :dressing_room

  #### validations:
  validates_presence_of :name, :label, :user_id
  #validates_uniqueness_of :name, scope: [:user_id], case_sensitive: false

  #### indexes:

  index [[:user_id, Mongo::ASCENDING], [:name, Mongo::ASCENDING]], unique: true

end

class DressingRoomItem
  include Mongoid::Document
  include Mongoid::Paranoia
  include DocumentComponents::WebLink

  #### relationships:

  embedded_in :dressing_room
end