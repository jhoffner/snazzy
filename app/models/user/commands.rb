class User

  module Commands
    extend ActiveSupport::Concern

    module ClassMethods
      def sign_in_with_auth_hash(auth_hash, access_token)
        user = User.find_by_auth_hash(auth_hash)

        if user
          user.last_sign_in_at = Time.now
        end

        if auth_hash[:provider] == 'facebook'
          if user
            user.fb_token = access_token if !access_token.blank?
          else
            # TODO: implement invite process instead of just creating a new user automatically
            # early return since this method will create the user - no need to save
            user = create_from_facebook(access_token)
            user.instance_variable_set "@auto_created_from_fb", true
          end
        end

        # note: this method should be smart enough to only save if changes were made
        user.save!

        user
      end

      def create_from_facebook(access_token)
        user = User.new
        user.update_user_attrs_using_fb(access_token)
        user.last_sign_in_at = Time.now
        user.save!

        user.create_default_rooms
        user
      end

    end

    # creates default dressing rooms for the user
    def create_default_rooms
      wish_list_name = 'Wish List'
      self.dressing_rooms.create label: wish_list_name unless self.dressing_rooms.any? {|room| room.label == wish_list_name}

      closet_name = 'My Closet'
      self.dressing_rooms.create label: closet_name unless self.dressing_rooms.any? {|room| room.label == closet_name}

      session_name = "My Cart"
      session_room = self.dressing_rooms.create label: session_name unless self.dressing_rooms.any? {|room| room.label == session_name}
      self.recent_dressing_room = session_room if self.recent_dressing_room.nil?
      self.save!
    end

  end
end