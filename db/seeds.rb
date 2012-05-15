# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)

User.create_indexes

user1 = User.create!(
    first_name: "jon",
    last_name: "doe",
    email: "jon.doe@gmail.com",
    username: "jon_doe",
    role: 's',
    fb_uid: "jondoefbuid"# not a valid id but it should still validate for now
)

DressingRoom.create_indexes
#DressingRoomItem.create_indexes

dr1 = user1.dressing_rooms.create!({
    label: 'Wish List',
    #username: user1.username,
    items: [
        {
            name: "test item 1",
            url: "http://www.test.com",
            image: {
                url: "http://www.test.com/image.png",
                width: 300,
                height: 400
            }#,
            #activites: [
            #    {
            #        type: 0,
            #        message: "Test message",
            #        user_id: user1.id
            #    },
            #    {
            #        type: 1,
            #        user_id: user1.id
            #    }
            #]
        },
        {
            name: "test item 2",
            url: "http://www.test.com",
            image: {
                url: "http://www.test.com/image2.png",
                width: 300,
                height: 300
            }
        }
    ]
})

item1 = dr1.items.first

item1.activities.create! type: 0, message: "Test message", user_id: user1.id
item1.activities.create! type: 1, user_id: user1.id

user1.dressing_rooms.create! label: "My Stuff"

Outfit.create_indexes
OutfitItem.create_indexes

outfit1 = dr1.outfits.create!({
  label: 'test outfit 1',
  #user_id: dr1.user_id,
  #username: user1.username,
  dressing_room_slug: dr1.slug,
  items: [
      {
          dressing_room_item_id: dr1.items.first.id
      },
      {
          dressing_room_item_id: dr1.items.last.id
      }
  ]
})
