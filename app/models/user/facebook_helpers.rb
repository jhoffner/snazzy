class User
  module FacebookHelpers
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

end