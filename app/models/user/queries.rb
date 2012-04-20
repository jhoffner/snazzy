class User
  module Queries
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
  end
end