class LoginsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to root_path
    else
      flash[:alert] = "The email or password you entered is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:current_user_id)
    @_current_user = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path, status: :see_other
  end
end
