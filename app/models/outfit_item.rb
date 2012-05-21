class OutfitItem
  include Model::EmbeddedDocument

  #### fields:
  field :dressing_room_item_id,   type: BSON::ObjectId

  #### relationships:
  embedded_in :outfit

  #### validations:
  validates_presence_of :dressing_room_item_id

  #### attributes

  # override dressing room item id setter to also set the dressing_room_item variable to nil so that the references remain in sync
  def dressing_room_item_id=(value)
    self[:dressing_room_item_id] = value
    @dressing_room_item = nil
  end

  def dressing_room_item
    if @dressing_room_item
      @dressing_room_item
    elsif dressing_room_item_id and outfit and outfit.dressing_room
      @dressing_room_item = outfit.dressing_room.items.find(dressing_room_item_id)
    else
      nil
    end
  end

  def dressing_room_item=(value)
    @dressing_room_item = value
    if value
      raise TypeError.new unless value.instance_of? DressingRoomItem
      self[:dressing_room_item_id] = value.id
    else
      self[:dressing_room_item_id] = nil
    end
  end
end