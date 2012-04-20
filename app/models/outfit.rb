class Outfit
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include DocumentComponents::FriendlyUrlName

  #### fields:

  #### relationships:

  embedded_in :dressing_room
  embeds_many :items, class_name: 'OutfitItem', inverse_of: :outfit

  #### validations:

  validates_presence_of :name, :label
  validates_uniqueness_of :name, case_sensitive: false

end

class OutfitItem
  include Mongoid::Document

  #### fields:
  field :dressing_room_item_id,     type: BSON::ObjectId

  #### relationships:
  embedded_in :outfit

  #### validations:
  validates_presence_of :dressing_room_item_id

  #### attributes

  def dressing_room_item
    if dressing_room_item_id and outfit and outfit.dressing_room
      outfit.dressing_room.items.find(dressing_room_item_id)
    else
      nil
    end
  end
end
