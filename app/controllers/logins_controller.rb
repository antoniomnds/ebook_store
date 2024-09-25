class LoginsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      login(user)
      redirect_to params[:back_url] || root_path,
                  notice: "You have successfully logged in.",
                  status: :see_other
    else
      flash[:alert] = "The email or password you entered is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "You have successfully logged out.", status: :see_other
  end
end
