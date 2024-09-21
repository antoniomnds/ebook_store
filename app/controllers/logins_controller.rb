class LoginsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to params[:back_url] || root_path,
                  notice: "You have successfully logged in.",
                  status: :see_other # FIXME its redirecting to the login page
    else
      flash[:alert] = "The email or password you entered is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:current_user_id)
    @_current_user = nil
    redirect_to root_path, notice: "You have successfully logged out.", status: :see_other
  end
end
