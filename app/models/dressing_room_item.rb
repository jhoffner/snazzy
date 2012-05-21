class DressingRoomItem
  include Model::EmbeddedDocument
  include Model::Prepared
  include Model::WebLink

  #include Mongoid::Paranoia
  include Mongoid::Timestamps::Created

  include DressingRoomItem::Commands
  include DressingRoomItem::Prepare

  #### relationships:

  embedded_in :dressing_room
  embeds_many :activities, class_name: 'DressingRoomItemActivity', inverse_of: :dressing_room_item do
    def build_like(hash = {})
      hash[:type] = DressingRoomItemActivity::TYPE_LIKE
      build(hash)
    end

    def build_dislike(hash = {})
      hash[:type] = DressingRoomItemActivity::TYPE_DISLIKE
      build(hash)
    end

    def build_comment(hash = {})
      hash[:type] = DressingRoomItemActivity::TYPE_COMMENT
      build(hash)
    end
  end

  #### fields:


  #### validations:

  validate :validate_uniqueness_of_new_image_url

  #### instance methods
  def dup_image?
    self.new? and self.image and dressing_room.items.any? do |item|
      item.image && item.image.url == self.image.url && item.id != self.id && (self.created_at.nil? or self.created_at > item.created_at)
    end
  end

  protected

  # NOTE: if i decide to make the error message more useful on the parent then I should implement a solution similar to this one: http://stackoverflow.com/questions/5501396/rails-mongoid-error-messages-in-nested-attributes
  # NOTE: this only checks for new records. existing records are not checked once they are saved
  def validate_uniqueness_of_new_image_url
    self.errors[:"image.url"] = 'Image url has already been added to this collection' if self.dup_image?
  end
end

class DressingRoomItemPrepared
  include Model::PreparedDocument

  #### fields:
  field :likes_count,       type: Integer, default: 0
  field :dislikes_count,    type: Integer, default: 0
  field :comments_count,    type: Integer, default: 0

end

class DressingRoomItemActivity
  include Model::EmbeddedDocument
  include Mongoid::Timestamps::Created

  #### consts

  TYPE_COMMENT = 0
  TYPE_LIKE = 1
  TYPE_DISLIKE = 2

  #### relationships

  belongs_to :user
  embedded_in :dressing_room_item

  #### fields:

  field :message,           type: String, limit: 200
  field :type,              type: Integer, required: true

  #### validations:

  validates_presence_of     :type, :user
  validates_presence_of     :message, if: :is_comment?

  validate :validate_uniqueness_of_type

  def validate_uniqueness_of_type
    if self.new? and is_vote? and dressing_room_item.activities
      user_votes = dressing_room_item.activities.where(user_id: self.user_id, :type.ne => TYPE_COMMENT).to_a
      if (user_votes.size > 1 and user_votes.first != self)
        self.errors[:type] = "User cannot vote multiple times"
      end
    end
  end

  #### methods

  def is_comment?
    type == TYPE_COMMENT
  end

  def is_vote?
    type != TYPE_COMMENT
  end

  def like?
    type == TYPE_LIKE
  end

  #### scopes

  scope :likes, where(type: TYPE_LIKE)
  scope :dislikes, where(type: TYPE_DISLIKE)
  scope :comments, where(type: TYPE_COMMENT)
  scope :votes, where(:type.ne => TYPE_COMMENT)
  scope :user, lambda {|user| where(user_id: user.id) }
end