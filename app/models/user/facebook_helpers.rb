class User
  module FacebookHelpers
    extend ActiveSupport::Concern

    def fb_profile_img_url
      "http://graph.facebook.com/#{fb_uid}/picture"
    end

    def fb_graph
      @fb_graph ||= Koala::Facebook::GraphAPI.new(self.fb_token)
    end

    def fb_profile
      unless @fb_profile or fb_token.blank?
        @fb_profile = fb_graph.get_object("me")
      end

      @fb_profile
    end

    def fb_profile=(profile)
      raise "invalid profile for this user" unless profile["id"] == fb_uid
      @fb_profile = profile
    end

    def update_user_attrs_using_fb (access_token)
      self.fb_token = access_token unless access_token.blank?
      return false unless self.fb_token

      self.email = fb_profile['email'] if self.email.blank?
      self.first_name = fb_profile['first_name'] if self.first_name.blank?
      self.last_name = fb_profile['last_name'] if self.last_name.blank?

      # if username is blank (a new record) then we need to generate one
      if self.username.blank?
        # try to use the username from facebook if one is available
        username = (fb_profile['username'] || "").downcase

        # if a facebook user name was not available then generate one
        if username.blank?
          self.username = "#{self.first_name}_#{self.last_name}".downcase

          #unless the name is available as is then a unique id needs to be suffixed to the user name
          unless User.username_available? self.username
            self.username += rand(1...1000).to_s
          end
        else
          self.username = username.gsub('.','_')
        end
      end

      self.fb_uid = fb_profile['id']

      if fb_profile['location'] && self.location.blank?
        self.location = fb_profile['location']['name']
        self.fb_location_id = fb_profile['location']['id']
      end

      self.gender_name = fb_profile['gender'] if self.gender.blank?
      self.timezone = fb_profile['timezone'] if self.timezone.nil?
      self.locale = fb_profile['locale'] if self.locale.nil?

      unless fb_profile['birthday'].blank?
        self.dob = Date.strptime(fb_profile['birthday'], '%m/%d/%Y') if self.dob.nil?
      end

      true
    end

    def is_fb_friends_with?(fb_uid)
      fb_friends.any? {|f| f['id'] == fb_uid}
    end

    def fb_friends
      @fb_friends ||= fb_graph.get_connections(fb_uid, "friends")
    end

    # returns fb friends that have associated accounts on this site - does not take into account
    def fb_friend_users
      unless @fb_friend_users
        fb_uids = fb_friends.select {|friend| friend['id'] }
        @fb_friend_users = User.fb_uids(fb_uids).to_a
      end

      @fb_friend_users
    end

    # discovers fb friends that have accounts on this site but have not yet been associated as friends on this site
    def unlinked_fb_friend_users
      @unlinked_fb_friend_users ||= fb_friend_users.find_all do |u|
        !friends.any? {|f| f.fb_uid == u.fb_uid}
      end
    end

    # discovers and links fb friends that have accounts on this site but have not yet been associated as friends on this site
    def discover_and_link_fb_friend_users
      unlinked_fb_friend_users.each {|u| add_friend u}
      @unlinked_fb_friend_users = nil
    end

    def fb_likes
      @fb_likes ||= fb_graph.get_connections(fb_uid, "likes")
    end


  end

end