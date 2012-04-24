module Snazzy
  module ModelHelper

    def build_key
      rand 10000
    end

    def build_valid_user
      user = Fabricate.build :user
      build_valid_dressing_room(user)
      user
    end

    def build_valid_dressing_room(user)
      key = build_key
      room = user.dressing_rooms.new label:"test dressing room #{key}"

      4.times do |i|
        room.items.new url: "http://www.test.com", image: Fabricate.build(:image)
      end

      2.times do |i|
        build_valid_outfit(room, i)
      end

      room
    end

    def build_valid_outfit(room, i)
      key = build_key
      outfit = room.outfits.new label: "test outfit #{key}"

      2.times do |x|
        outfit.items.new dressing_room_item_id: room.items[(i == 0 ? 0 : 2) + x].id
      end

      outfit
    end

    def test_validates_uniqueness_of(existing_record, new_record, field)
      valid_value = new_record.send field
      invalid_value = existing_record.send field

      test_valid_value(new_record, field, valid_value)
      test_invalid_value(new_record, field, invalid_value)
    end

    def test_validates_presence_of(record, field, valid_value)
      test_invalid_value(record, field, nil)
      test_invalid_value(record, field, '') if valid_value.instance_of? String

      test_valid_value(record, field, valid_value)
    end

    def test_validates_format_of(record, field, invalid_value, valid_value)
       test_invalid_value(record, field, invalid_value)
       test_valid_value(record, field, valid_value)
    end

    def test_validates_inclusion_of(record, field, invalid_values, valid_values)
       invalid_values.each do |value|
         test_invalid_value(record, field, value)
       end

       valid_values.each do |value|
         test_valid_value(record, field, value)
       end
    end

    def test_invalid_value(record, field, invalid_value)
      record.set_attr field, invalid_value

      record.invalid?.should be_true
      record.errors.should have_key field
    end

    def test_valid_value(record, field, valid_value)
      record.set_attr field, valid_value
      record.valid? #dont check the result of this test as it may still be false due to other errors not apart of this test

      record.errors.should_not have_key field
    end
  end
end