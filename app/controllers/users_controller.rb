class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users
  def index
    @users = User.all
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
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      session[:current_user_id] = @user.id
      redirect_to @user, notice: "User was successfully created."
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
    begin
      @user.destroy!
      @user.avatar.purge_later

      redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
    rescue ActiveRecord::InvalidForeignKey
      redirect_to request.referer,
                  alert: "User already bought ebooks. Cannot be destroyed.",
                  status: :see_other
    rescue ActiveRecord::RecordNotDestroyed => e
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
