class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :require_login, only: %i[ edit update ] # to change password
  skip_before_action :verify_current_user, only: %i[ edit update ] # to avoid loop in these actions

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
    unless @user == current_user || current_user.admin?
      redirect_to root_url,
                  alert: "You can only edit your own profile.",
                  status: :see_other
    end
  end

  # PATCH/PUT /users/1
  def update
    unless @user == current_user || current_user.admin?
      return redirect_to root_url,
                  alert: "You can only edit your own profile.",
                  status: :see_other
    end
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    own_user = @user == current_user
    unless own_user or current_user.admin?
      return redirect_to root_url,
                         alert: "You can only delete your own profile.",
                         status: :see_other
    end

    begin
      @user.deactivate!
      @user.avatar.purge_later
      if own_user
        logout
      end

      redirect_to root_url, notice: "User was successfully removed.", status: :see_other
    rescue ActiveRecord::RecordInvalid => e
      redirect_to request.referer,
                  alert: "User could not be destroyed. #{ e.message }",
                  status: :see_other
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :enabled, :avatar, :password_challenge,
                                   :password, :password_confirmation)
    end
end
