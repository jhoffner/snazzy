# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
    first_name: "jon",
    last_name: "doe",
    email: "jon.doe@gmail.com",
    password: "password",
    username: "jon_doe",
    user_type: 's',
    fb_uid: "jondoefbuid" # not a valid id but it should still validate
)