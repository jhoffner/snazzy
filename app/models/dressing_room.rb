class DressingRoom
  include Mongoid::Document

  #### relationships:

  belongs_to :user
  embeds_many :dressing_room_items

  #### fields:

  field :name,          type: String
  field :created_on,    type: Time,   default: -> {Time.now}

  #### validations:

  validates_presence_of :name
end

class DressingRoomItem
  include Mongoid::Document
  include RegexHelper

  #### relationships:

  embedded_in :dressing_room

  #### fields:

  field :name,          type: String
  field :url,           type: String
  field :image_url,     type: String
  field :description,   type: String
  field :price,         type: Float

  #### validations:

  validates_presence_of :url, :image_url
end