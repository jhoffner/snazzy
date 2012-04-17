
class User::EditPresenter < ApplicationPresenter
  delegate :user, :to => :controller

  def setup

  end
end