Fabricator :dressing_room do
  key = rand(5000)
  label "test dressing room #{key}"
  slug "test-dressing-room-#{key}"
  #user
  #user_id { |room| room.user.id }
  #username {|room| room.user.username }

  items(count: 4) do |room, i|
    Fabricate.build :dressing_room_item do
      image_url "http://www.test.com/image_#{i}.png"
    end
  end

  #outfits(count: 2) do |room, i|
  #  outfit = room.outfits.new label: "test outfit #{i}"
  #  outfit.dressing_room = room
  #  outfit
  #  #Fabricate.build :outfit do
  #  #  dressing_room room
  #  #  dressing_room_slug room.slug
  #  #  slug "test-outfit-#{i}"
  #  #  label "test outfit #{i}"
  #  #end
  #end
end