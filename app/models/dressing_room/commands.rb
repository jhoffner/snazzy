class DressingRoom
  module Commands
    extend ActiveSupport::Concern

    def invite_fb_uid(fb_uid)
      invite_fb_uids([fb_uid])
    end

    def invite_fb_uids(fb_uids)
      self.invited_fb_uids ||= []
      self.invited_fb_uids |= fb_uids

      # TODO: find a way to mark the invited_fb_uids as not dirty even though they changed

      add_to_set(:invited_fb_uids, fb_uids)
      add_collaborators User.fb_uids(fb_uids).only(:id).to_a
    end

    def add_collaborator(user)
      raise "owning user cannot also be collaborator" if user.id == self.user_id

      collaboration = self.collaborators.create(user: user)
      user.add_to_set(:collaborating_dressing_room_ids, self.id)
      self.user.add_friend(user)
    end

    def add_collaborators(users)
      users.each do |user|
        add_collaborator(user)
      end
    end

  end
end