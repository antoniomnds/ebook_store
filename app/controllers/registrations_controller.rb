class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  # GET /registrations/new
  def new
    @user = User.new
  end

  # POST /registrations
  def create
    @user = User.new(user_params)

    if @user.save
      login(@user)
      UserMailer.welcome(@user).deliver_later
      redirect_to root_url, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
