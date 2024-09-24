class LoginsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :verify_current_user, only: %i[new]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      return redirect_to new_login_path,
                         alert: "Your account has been disabled.",
                         status: :see_other unless user.enabled?

      session[:current_user_id] = user.id
      redirect_to params[:back_url] || root_path,
                  notice: "You have successfully logged in.",
                  status: :see_other
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
