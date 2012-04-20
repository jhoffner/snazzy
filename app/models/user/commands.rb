class User

  module Commands
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