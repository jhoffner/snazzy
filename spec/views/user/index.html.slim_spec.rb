require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:user, [
      stub_model(User,
        :username => "User Name",
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :password => "Password"
      ),
      stub_model(User,
        :username => "User Name",
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :password => "Password"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User Name".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
  end
end
