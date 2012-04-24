class UserController < ApplicationController

  # for now all actions in this controller should require authentication
  before_filter :authenticate_user!

  def settings

  end

  # GET /user
  # GET /user.json
  def index
    params[:id] = current_user_id
    show
  end

  # GET /user/1
  # GET /user/1.json
  def show
    if check_user_access
      respond_to do |format|
        format.html { render :show }
        format.json { render json: user || {} }
      end
    end
  end

  # GET /user/1/edit
  def edit
    check_user_access

    @presenter = User::EditPresenter.new self
  end

  # PUT /user/1
  # PUT /user/1.json
  def update
    respond_to do |format|
      if user.update_attributes(params[:user])
        format.html { redirect_to user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user/1
  # DELETE /user/1.json
  def destroy
    if check_user_access
      user.destroy

      respond_to do |format|
        format.html { redirect_to :root }
        format.json { head :no_content }
      end
    end
  end



end
