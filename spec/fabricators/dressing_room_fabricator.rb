Fabricator :dressing_room do
  label "test dressing room"
  name "test_dressing_room"
  user { Fabricate.build(:user) }
  #user_id { |room| room.user.id }
  #username {|room| room.user.username }

  items(count: 4) do |room, i|
    Fabricate.build :dressing_room_item do
      image_url "http://www.test.com/image_#{i}.png"
    end
  end
end