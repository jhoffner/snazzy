Fabricator(:outfit) do
  name "test-outfit"
  label "Test Outfit",
  dressing_room { Fabricate.build(:dressing_room) }
  #dressing_room_id {|outfit| outfit.dressing_room_id }

  user {|outfit| outfit.dressing_room.user }
  #user_id {|outfit| outfit.dressing_room.user_id }

  items(count: 2) do |outfit, i|
    Fabricate.build :outfit_item do
      dressing_room_item_id outfit.dressing_room.items[i].id
    end
  end
end
