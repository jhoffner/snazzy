Fabricator :dressing_room do
  label "test dressing room"
  name "test_dressing_room"
  user { Fabricate.build(:user) }
  user_id { |room| room.user.id }

  items(count: 4) do |room, i|
    Fabricate.build :dressing_room_item do
      image_url "http://www.test.com/image_#{i}.png"
    end
  end

  outfits(count: 2) do |room, i|
    Fabricate.build :outfit do
      name "test-outfit-#{i}"
      label "test outfit #{i}"

      items(count:2) do |outfit, x|
        Fabricate.build :outfit_item do
          dressing_room_item_id room.items[i+x].object_id
        end
      end
    end
  end
end