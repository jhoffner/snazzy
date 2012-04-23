class DressingRoomsController < ApplicationController
  # for now all actions in this controller should require authentication
  before_filter :authenticate_user!

  def index
  end

  def show
  end

  def destroy
  end
end
