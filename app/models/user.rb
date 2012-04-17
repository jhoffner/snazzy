#require 'user/singletons'

class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  include RegexHelper

  #### consts:

  ADMIN_USER = 'a'
  STANDARD_USER = 's'

  #### relationships:

  has_many :dressing_rooms

  ##### fields:

  field :username,                type: String
  field :email,                   :type => String, :null => false
  field :last_sign_in_at,         :type => Time

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

  #validates_uniqueness_of         :fb_uid

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

  validates_format_of             :email,
                                  with: EmailFormat

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

  def admin?
    self.user_type == ADMIN_USER
  end

  def make_admin
    self.user_type = ADMIN_USER
  end

  def load_fb_profile(access_token = nil)
    self.fb_token = access_token unless access_token.blank?
    return false if self.fb_token.blank?

    @fb_graph = Koala::Facebook::API.new(self.fb_token) unless @fb_graph
    @fb_profile = @fb_graph.get_object("me") unless @fb_profile
    true
  end

  def update_user_attrs_using_fb (access_token)
    return false unless load_fb_profile(access_token)

    self.email = @fb_profile['email'] if self.email.blank?
    self.first_name = @fb_profile['first_name'] if self.first_name.blank?
    self.last_name = @fb_profile['last_name'] if self.last_name.blank?

    # if username is blank (a new record) then we need to generate one
    if self.username.blank?
      # try to use the username from facebook if one is available
      username = @fb_profile['username']

      # if a facebook user name was not available then generate one
      if username.blank?
        self.username = "#{self.first_name}_#{self.last_name}"

        #unless the name is available as is then a unique id needs to be suffixed to the user name
        unless User.username_available? self.username
           self.username += rand(1...1000).to_s
        end
      else
        self.username = username.gsub('.','_')
      end
    end

    self.fb_uid = @fb_profile['id']

    if @fb_profile['location'] && self.location.blank?
      self.location = @fb_profile['location']['name']
      self.fb_location_id = @fb_profile['location']['id']
    end

    self.gender_name = @fb_profile['gender'] if self.gender.blank?
    self.timezone = @fb_profile['timezone'] if self.timezone.nil?
    self.locale = @fb_profile['locale'] if self.locale.nil?

    unless @fb_profile['birthday'].blank?
      self.dob = Date.strptime(@fb_profile['birthday'], '%m/%d/%Y') if self.dob.nil?
    end

    true
  end

  #### singletons

  class << self

    def find_by_username(username)
      User.where(username: username).first
    end

    def find_by_id_or_username(id_or_username)
      User.any_of({_id: id_or_username}, {username: id_or_username}).first
    end

    def username_available?(username)
      User.where(username: username).exists?
    end

    def find_by_fb_uid(uid)
      User.where(fb_uid: uid).first
    end

    def find_by_auth_hash(auth_hash)
      case auth_hash[:provider]
        when 'facebook'
          find_by_fb_uid(auth_hash[:uid])
        when 'pinterest'
          User.where(pinterest_uid: auth_hash[:uid]).limit(1)
        else
          nil
      end
    end

    def sign_in_with_auth_hash(auth_hash, access_token)
      user = User.find_by_auth_hash(auth_hash)

      if auth_hash[:provider] == 'facebook'
        if user
          user.fb_token = access_token if !access_token.blank?
        else
          # TODO: implement invite process instead of just creating a new user automatically
          user =  User.new
          user.update_user_attrs_using_fb(access_token)
          user.instance_variable_set "@auto_created_from_fb", true
        end
      end

      if user
        user.last_sign_in_at = Time.now
        user.save!
      end

      user
    end
  end

end


