class DressingRoomsController < ApplicationController
  # for now all actions in this controller should require authentication
  before_filter :authenticate_user!, :check_user_access

  def index
    @rooms = DressingRoom
      .where(user_id: current_user_id)
      .only(:slug, :label, :username, :prepared)
      .to_a
  end

  def show
  end

  def create

  end

  def destroy
  end
end
