class Friendship
  include Model::RootDocument
  include Mongoid::Timestamps::Created

  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
end
