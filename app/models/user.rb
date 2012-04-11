class User
  include Mongoid::Document
  include RegexHelper

  #### consts:

  ADMIN_USER = 1
  STANDARD_USER = 0

  #### relationships:

  has_many :dressing_rooms

  ##### fields:

  field :user_type,         type: Integer,  default: 0

  field :login,             type: String
  field :email,             type: String
  field :password,          type: String

  field :first_name,        type: String
  field :last_name,         type: String

  field :fb_uid,            type: String
  field :fb_token,          type: String

  field :twitter_name,      type: String

  field :created_on,        type: Time,     default: -> {Time.now}
  field :last_login_on,     type: Time

  attr_protected :created_on, :last_login_on

  #### validations:

  validates_numericality_of :user_type,
                            less_than: 2,
                            greater_than_or_equal_to: 0

  validates_presence_of     :login, :first_name, :last_name, :email

  # password is only required if facebook account was not linked
  validates_presence_of     :password,
                            if: -> {fb_uid.blank?},
                            message: "Password is required since a Facebook account is not linked"

  validates_uniqueness_of   :login, :email,
                            on: :create

  validates_length_of       :login,
                            minimum: 2

  validates_format_of       :email,
                            with: EmailFormat

  #### methods

  def admin?
    self.user_type == ADMIN_USER
  end

  def make_admin
    self.user_type = ADMIN_USER
  end
end
