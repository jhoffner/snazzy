class ApplicationController < ActionController::Base
  protect_from_forgery

  ### authentication:
  helper_method :authenticated?, :current_user, :current_user_id, :current_username, :admin_user?

  def authenticate_user!
    if authenticated?
      true
    else
      session[:return_to] = request.original_url
      redirect_to controller: :session, action: :new
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
    reset_session
    @current_user = user
    session[:user_id] = user.id.to_s
    session[:username] = user.username
    session[:first_name] = user.first_name
    session[:last_name] = user.last_name
  end

  def logout_user
    reset_session
    @current_user = nil
  end

  def authenticated?
    !current_user_id.blank?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if authenticated?
  end

  def current_user_id
    session[:user_id]
  end

  def current_username
    session[:username]
  end

  def admin_user?
    current_user.admin? if current_user
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

  def render_no_access(model_name)
    @model_name = model_name
    respond_to do |format|
      format.html { render "shared/no_access" }
      format.json { render json: {error: "access denied"} }
    end
  end
end
