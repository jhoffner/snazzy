require 'spec_helper'

describe FacebookController do

  describe "GET 'friends_picker'" do
    it "returns http success" do
      get 'friends_picker'
      response.should be_success
    end
  end

end
