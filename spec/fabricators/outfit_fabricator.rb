Fabricator(:outfit) do
  key = rand(5000)
  slug "test-outfit-#{key}"
  label "Test Outfit-#{key}"
  #dressing_room
  #dressing_room do |outfit|
  #  room = Fabricate.build :dressing_room
  #  room.outfits.insert outfit
  #  room
  #end
  #dressing_room_slug {|outfit| outfit.dressing_room.slug}
  #dressing_room_id {|outfit| outfit.dressing_room_id }

  #user {|outfit| outfit.dressing_room.user }
  #user_id {|outfit| outfit.dressing_room.user_id }

  #items(count: 2) do |outfit, i|
  #  Fabricate.build :outfit_item do
  #    dressing_room_item_id outfit.dressing_room.items[i].id
  #  end
  #end
end
