class Outfit
  include Model::RootDocument
  include Model::Slug
  include Model::UserDependant
  include Model::DressingRoomDependant

  include Outfit::Queries

  #### relationships:

  embeds_many :items, class_name: 'OutfitItem', inverse_of: :outfit

  #### fields:

  field :tags,                type: String

  #### validations:

  validates_uniqueness_of :slug, scope:[:dressing_room_id], case_sensitive: false

  #index [[:username, Mongo::ASCENDING], [:dressing_room_name, Mongo::ASCENDING], [:name, Mongo::ASCENDING]], unique: true

  #### attributes


  #### methods


end


