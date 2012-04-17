class SessionController < ApplicationController

  def facebook
    unless params[:return_to].blank?
      session[:return_to] = params[:return_to]
    end

    redirect_to '/auth/facebook'
  end

  def create
    auth_hash = request.env['omniauth.auth']
    token = request.env['omniauth.strategy'].access_token.token
    user = User.sign_in_with_auth_hash(auth_hash, token)

    login_user(user)
    return_to_url(root_path)
  end

  def new
    if authenticated?
      return_to_url(root_path)
    end
  end

  def destroy
    logout_user
    return_to_url(root_path, notice: "You have successfully logged out")
  end

  def failure
    flash[:error] = "Login failed!"
    return_to_url(root_path)
  end
end
