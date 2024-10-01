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
      session[:current_user_id] = @user.id
      UserMailer.welcome(@user).deliver_later
      redirect_to root_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
end
