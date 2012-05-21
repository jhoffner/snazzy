class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_valid_session

  class << self

    # @param [Symbol] name
    # @param [Block] block
    def expose_presenter(name, default_type = :default, &block)
      _expose_presenter_or_presenters(:presenter, name, default_type, &block)
    end

    # @param [Symbol] name
    # @param [Block] block
    def expose_presenters(name, default_type = :default, &block)
      _expose_presenter_or_presenters(:presenters, name, default_type, &block)
    end

    private

    def _expose_presenter_or_presenters(method_name, name, default_type, &block)
      default_exposure = begin self.default_exposure rescue nil end
      define_method name do |type = default_type, attributes = {}|
        @_resources ||= {}
        @_resources.fetch(name) do
          model = if block_given?
                    instance_eval(&block)
                  else
                    instance_exec(name, &default_exposure)
                  end

          @_resources[name] = send method_name, type, model, attributes
        end
      end

      define_method "#{name}=".to_sym do |value|
        @_resources ||= {}
        @_resources[name] = value
      end

      helper_method name
      hide_action name
    end

  end

  expose_presenter :user do
    id_or_username = params[:user_id] || params[:username]
    case id_or_username
      # if the id/username is for the current user, or the id is not provided then use the current user
      when session_user_id, session_username, nil
        session_user
      else
        User.find_by_id_or_username(id_or_username)
    end
  end

  def presenter(type = nil, model = nil, attributes = {}, &block)
    ApplicationPresenter.presenter(self, determine_presenter_type(type), model, attributes, &block)
  end

  def presenters(type = nil, models = nil, attributes = {}, &block)
    ApplicationPresenter.presenters(self, determine_presenter_type(type), models, attributes, &block)
  end

  ### authentication:
  helper_method :authenticated?, :session_user, :session_user_id, :session_username, :admin_user?

  def check_valid_session
    if session[:user_id] and session_user.nil?
      session.clear
      flash[:warning] = "Your session has expired"
    end
  end

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

  def determine_presenter_type(type)
    #types = [action_name.to_sym, :default]
    #types.unshift(type) if type
    #types

    type || :default
  end

  def handle_user_no_access(raise_exception = false)
    if authenticate_user!(raise_exception: raise_exception)
      if user.nil?
        if raise_exception
          raise "Resource not found"
        else
          render_404
        end

        false

      elsif raise_exception
        raise "User does not have access"
        false
      else
        render_no_access
        false
      end
    end
  end

  def check_user_read_access(raise_exception = false)
    if session_user? || admin_user?
      true
    else
      handle_user_no_access(raise_exception)
    end
  end

  # ensures that the user has permission to see the resource.
  def check_user_write_access(raise_exception = false)
    check_user_read_access(raise_exception)
  end

  def assert_param_presence(name, msg = "#{name} param is missing")
    raise msg if params[name].blank?
  end

  # ensures that the user is authenticated
  def authenticate_user!(options = {})
    options.defaults = {
        return_to: request.original_url,
        controller: :session,
        action: :new,
        raise_exception: false
    }

    if authenticated?
      true
    elsif options[:raise_exception]
      raise "User is not authenticated"
    else
      session[:return_to] = options[:return_to]
      redirect_to controller: options[:controller], action: options[:action]
      false
    end
  end

  def authenticate_admin!(options = {})
    options.defaults = {
        return_to: request.original_url,
        controller: :session,
        action: :new,
        raise_exception: false
    }

    if authenticated? and admin_user?
      true
    elsif options[:raise_exception]
      raise "User is not authenticated with admin level permissions"
    else
      flash[:warning] = "You must be logged in as an admin to perform this action"
      session[:return_to] = options[:return_to]
      redirect_to controller: options[:controller], action: options[:action]
      false
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

  alias :render_json :render_json_success

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
