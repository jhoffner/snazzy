require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe UserController do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        username: 'unique_user',
        first_name: 'test',
        last_name: 'user',
        email: 'testuser@test.com',
        fb_uid: 'testfbid'
    }
  end

  describe "GET index" do
    it "handles the current logged in user and assigns them as user" do
      get :index, {}, valid_session
      controller.user.should eq existing_user
    end

    it "redirects if the user is not logged in" do
      get :index
      response.should redirect_to new_session_path
    end
  end

  describe "GET show" do
    it "assigns the requested user as user" do
      get :show, {:id => existing_user.to_param}, valid_session
      controller.user.should eq existing_user
    end
  end

  describe "GET edit" do
    it "assigns the requested user as user" do
      get :edit, {:id => existing_user.to_param}, valid_session
      controller.user.should eq existing_user
    end

    it "assigns a presenter instance" do
      get :edit, {:id => existing_user.to_param}, valid_session
      assigns(:presenter).user.should eq existing_user
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before do
        @update_attrs = {
            first_name: 'name2'
        }

        put :update, {:id => existing_user.to_param, :user => @update_attrs}, valid_session
      end

      it "updates the requested user" do
        controller.user.first_name.should eq @update_attrs[:first_name]
      end

      it "assigns the requested user as user" do
        controller.user.username.should eq existing_user.username
      end

      it "redirects to the user" do
        response.should redirect_to(existing_user)
      end
    end

    describe "with invalid params" do
      before do
        existing_user.stub(:save).and_return(false)

        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => existing_user.to_param, :user => {email: nil}}, valid_session
      end

      it "assigns the user as user" do
        controller.user.should eq existing_user
      end

      it "re-renders the 'edit' template" do
        response.should render_template "edit"
      end
    end
  end

  describe "DELETE destroy" do

    it "destroys the current user" do
      expect {
        delete :destroy, {:id => existing_user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "fails to destroy another user because the current user is not an admin" do
      delete :destroy, {:id => "some other id"}, valid_session
      response.should render_template "common/no_access"
    end

    it "is able to destroy another user because the current user is an admin" do
      existing_user.user_type = User::ADMIN_USER

      existing_count = User.count

      other_user = User.create!(valid_attributes)

      User.count.should eq(existing_count+1)

      expect {
        delete :destroy, {:id => other_user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the root" do
      delete :destroy, {:id => existing_user.to_param}, valid_session
      response.should redirect_to :root
    end
  end

  describe "PUT set_recent_room" do
    it "should successfully change the recent room" do
      user = User.find(valid_session[:user_id])
      user.should_not be_nil
      user.dressing_rooms.count.should > 1
      user.recent_dressing_room_id = user.dressing_rooms.first.id
      user.save!

      post :set_recent_room, {id: user.dressing_rooms.last.id.to_s}, valid_session
      json = JSON.parse(response.body)
      #json[:success].should be_true
      user = User.find(valid_session[:user_id])
      user.recent_dressing_room_id.should eq user.dressing_rooms.last.id
    end
  end

end
