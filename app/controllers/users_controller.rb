class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :require_login, only: %i[ new create edit update ] # to sign up and change password

  # GET /users
  def index
    @users = User.active
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    redirect_to root_path,
                alert: "You can only edit your own profile.",
                status: :see_other unless @user == current_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      login(@user)
      UserMailer.welcome(@user).deliver_later
      redirect_to root_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    redirect_to request.referer,
                alert: "You can only delete your own profile.",
                status: :see_other unless @user == current_user

    begin
      @user.inactivate!
      @user.avatar.purge_later
      logout

      redirect_to root_path, notice: "User was successfully destroyed.", status: :see_other
    rescue ActiveRecord::RecordInvalid => e
      redirect_to request.referer,
                  alert: "User could not be destroyed. #{ e.message }",
                  status: :see_other
    end
  end

  def ebooks
    @ebooks = current_user.ebooks

    render "ebooks/index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.active.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :enabled, :avatar, :password_challenge,
                                   :password, :password_confirmation)
    end
end
