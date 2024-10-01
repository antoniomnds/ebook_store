class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login

  # Finds the User with the ID stored in the session with the key :current_user_id.
  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end
  helper_method :current_user

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def require_login
    redirect_to edit_user_path(current_user),
                alert: "Your password has expired. Please update your password.",
                status: :see_other if current_user&.password_expired?

    redirect_to new_session_path,
                alert: "You must be logged in to access this page.",
                status: :see_other unless logged_in?
  end

  def login(user)
    session[:current_user_id] = user.id
  end

  def logout
    session.delete(:current_user_id)
    @_current_user = nil
  end
end
