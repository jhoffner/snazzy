
module Snazzy
  module ControllerHelper
    def existing_user
      @existing_user ||= User.first
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # UsersController. Be sure to keep this updated too.
    def valid_session
      {
          user_id: existing_user.id.to_s,
          username: existing_user.username
      }
    end
  end
end