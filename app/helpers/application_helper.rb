lib_require('extensions/helpers')

module ApplicationHelper

  def current_user_full_name
    "#{session[:first_name]} #{session[:last_name]}" if authenticated?
  end


  #### UI helpers

  ### CSS Helpers:
  def css_display_none_if(should_hide)
    should_hide ? "display:none;" : ""
  end

  def css_display_none
    css_display_none_if(true)
  end

  ### link helpers
  def link_to_user(user = session_user, always_use_full_name = false)
    label = (authenticated? and session_user.id == user.id and !always_use_full_name) ? "You" : user.full_name
    link_to label, dressing_rooms_path(user.username)
  end

end
