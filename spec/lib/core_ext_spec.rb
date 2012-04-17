require 'spec_helper'

describe Hash do

  it "should support defaults" do

    h = {name: "a"}
    h.defaults = {name: "b", id: 1}

    h[:name].should == "a"
    h[:id].should == 1
  end
end