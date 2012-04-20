require 'spec_helper'

describe "User" do
  describe "GET /user" do
    it "non-logged in user should be redirected" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_path
      response.status.should be(302)
    end
  end
end
