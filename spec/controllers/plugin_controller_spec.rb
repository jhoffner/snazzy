require 'spec_helper'

describe PluginController do

  describe "GET 'bar'" do
    it "returns http success" do
      get 'bar'
      response.should be_success
    end
  end

end
