lib_require('extensions/helpers')

module ApplicationHelper

  def current_user_full_name
    "#{session[:first_name]} #{session[:last_name]}" if authenticated?
  end

end
