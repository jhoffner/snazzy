class HomeController < ApplicationController
  def index
    if !authenticated?
      return landing
    end
  end

  def landing
    render "landing"
  end

  def tos

  end

end
