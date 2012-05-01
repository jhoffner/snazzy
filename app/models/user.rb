class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  include User::Queries
  include User::FacebookHelpers
  include User::Commands
  include User::CallbackHandlers

  #### consts:

  ADMIN_USER = 'a'
  STANDARD_USER = 's'

  #### relationships:

  has_many :dressing_rooms, dependent: :delete, autosave: true

  has_many :outfits, dependent: :delete

  belongs_to :recent_dressing_room, class_name: "DressingRoom"

  ##### fields:

  field :username,                type: String
  field :email,                   type: String, null: false
  field :last_sign_in_at,         type: Time

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable, :confirmable,
  #       :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable

  #field :encrypted_password,      :type => String, :null => false, :default => ""

  ## Recoverable
  #field :reset_password_token,    :type => String
  #field :reset_password_sent_at,  :type => Time

  ## Rememberable
  #field :remember_created_at,     :type => Time

  ## Trackable
  #field :sign_in_count,           :type => Integer, :default => 0
  #field :current_sign_in_at,      :type => Time

  #field :current_sign_in_ip,      :type => String
  #field :last_sign_in_ip,         :type => String

  ## Encryptable
  #field :password_salt, :type => String

  ## Confirmable
  #field :confirmation_token,      :type => String
  #field :confirmed_at,            :type => Time
  #field :confirmation_sent_at,    :type => Time
  #field :unconfirmed_email,       :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  field :user_type,               type: String,  default: 's'

  field :first_name,              type: String
  field :last_name,               type: String
  field :gender,                  type: String
  field :website,                 type: String
  field :location,                type: String
  field :fb_location_id,          type: Integer
  field :about,                   type: String
  field :timezone,                type: Integer
  field :locale,                  type: String
  field :dob,                     type: Date

  field :fb_uid,                  type: String
  field :fb_token,                type: String

  field :pinterest_uid,           type: String

  field :twitter_name,            type: String

  attr_protected                  :last_sign_in_at

  #### validations:

  validates_presence_of           :username, :first_name, :last_name, :fb_uid

  # password is only required if facebook account was not linked
  #validates_presence_of          :password,
  #                               if: -> {fb_uid.blank?},
  #                               message: "Password is required since a Facebook account is not linked"

  validates_uniqueness_of         :fb_uid, :username, :email

  validates_length_of             :id,
                                  minimum: 2

  validates_inclusion_of          :gender,
                                  in: ['m','f'],
                                  message: 'invalid gender',
                                  allow_nil: true

  validates_inclusion_of          :user_type,
                                  in: ['s', 'a'],
                                  message: 'invalid user type',
                                  allow_nil: false

  validates_exclusion_of          :username,
                                  # need to prevent these values since they are used in the url routing structure
                                  in: %w{search plugin extension api help landing about settings public pub assets name username},
                                  message: 'is a reserved name'

  validates_format_of             :username,
                                  with: RegexHelper::NoWhiteSpace

  validates_format_of             :email,
                                  with: RegexHelper::EmailFormat

  #### indexes

  index                           :username, unique: true
  index                           :email, unique: true
  index                           :fb_uid, unique: true, sparse: true

  #### attributes

  attr_accessor                   :fb_profile

  #### methods

  def auto_created_from_fb?
    @auto_created_from_fb ||= false
  end
  #
  # get the display name of the gender value
  #
  def gender_name
    case gender
      when 'm'
        'male'
      when 'f'
        'female'
      else
        ''
    end
  end

  #
  # sets the gender code value by display name. valid values are 'male' and 'female'
  #
  def gender_name=(value)
    case value
      when 'male'
        gender = 'm'
      when 'female'
        gender = 'f'
    end
  end

  def full_name
    if !first_name.blank? and !last_name.blank?
      "#{first_name} #{last_name}"
    else
      first_name.blank? ? last_name : first_name
    end
  end

  def admin?
    self.user_type == ADMIN_USER
  end

  def make_admin
    self.user_type = ADMIN_USER
  end

end



