class ApplicationController < ActionController::Base
  protect_from_forgery

  expose :user do
    id_or_username = params[:user_id] || params[:username]
    case id_or_username
      # if the id/username is for the current user, or the id is not provided then use the current user
      when session_user_id, session_username, nil
        session_user
      else
        User.find_by_id_or_username(id_or_username)
    end
  end

  ### authentication:
  helper_method :authenticated?, :session_user, :session_user_id, :session_username, :admin_user?

  def session_user?
    id_or_username = params[:user_id] || params[:username]
    case id_or_username
      # if the id/username is for the current user, or the id is not provided then use the current user
      when session_user_id, session_username, nil
        true
      else
        false
    end
  end

  private

  def check_user_read_access
    if session_user? || admin_user?
      true
    elsif authenticate_user!
      if user.nil?
        render_404
        false
      else
        render_no_access
        false
      end
    else
      false
    end
  end

  # ensures that the user has permission to see the resource.
  def check_user_write_access
    check_user_read_access
  end

  def assert_param_presence(name, msg = "#{name} param is missing")
    raise msg if params[name].blank?
  end

  # ensures that the user is authenticated
  def authenticate_user!(return_to = request.original_url, controller = :session, action = :new)
    if authenticated?
      true
    else
      session[:return_to] = return_to
      redirect_to controller: controller, action: action
      false
    end
  end

  def authenticate_admin!
    if authenticate_user! and admin_user?
      true
    else
      session[:return_to] = request.original_url
      flash[:warning] = "You must be logged in as an admin to perform this action"
      redirect_to new_session_path
    end

  end

  def login_user(user)
    # this is the one value we need to retain from the session after we reset it
    return_to = session[:return_to]

    reset_session

    @session_user = user
    session[:user_id] = user.id.to_s
    session[:username] = user.username
    session[:first_name] = user.first_name
    session[:last_name] = user.last_name
    session[:return_to] = return_to
  end

  def logout_user
    reset_session
    @session_user = nil
  end

  def authenticated?
    !session_user_id.blank?
  end

  def session_user
    @session_user ||= User.find(session[:user_id]) if authenticated?
  end

  def session_user_id
    session[:user_id]
  end

  def session_username
    session[:username]
  end

  def admin_user?
    session_user.admin? if session_user
  end

  #
  # Returns to the "return_to" url stored within the query string or session. Returns true if there was a return_to
  # url to return to, otherwise false. Callers should check for false and do their own redirection, or pass in a default_return_to value
  #
  def return_to_url(default_return_to = nil, options = {})
    return_to = params[:return_to] || session[:return_to] || default_return_to
    if !return_to.blank?
      session[:return_to] = nil
      redirect_to return_to, options
      true
    else
      false
    end
  end

  def render_json_success
    begin
      json_hash = {success: true}
      yield json_hash if block_given?
      render json: json_hash
    rescue => ex
      p "json failure with exception #{ex.to_s}"
      render_json_failure(ex.message)
    end
  end

  def render_json_failure(message = "Unknown error")
    p "rendering json failure with message: #{message}"
    render json: {success: false, message: message}
  end

  def render_404
    respond_to do |format|
      format.html { render "shared/404" }
      format.json { render_json_failure "resource not found" }
    end
  end

  def render_no_access()
    respond_to do |format|
      format.html { render "shared/no_access" }
      format.json { render_json_failure "access denied" }
    end
  end
end
