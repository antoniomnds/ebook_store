class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include AuthenticationHelper # makes methods available to all controllers
  helper AuthenticationHelper # makes methods available to the view layer

  before_action :load_current_user
  before_action :require_login
  before_action :verify_current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def require_login
    unless logged_in?
      redirect_to new_session_url,
                  alert: "You must be logged in to access this page.",
                  status: :see_other
    end
  end

  # Performs some checks before allowing access to the application, namely:
  # - User's password must not be expired
  # - User must not be disabled
  def verify_current_user
    return unless logged_in?

    if current_user.password_expired?
      return redirect_to edit_user_url(current_user),
                         alert: "Your password has expired. Please update your password.",
                         status: :see_other
    end

    unless current_user.enabled?
      session.delete(:current_user_id)
      @_current_user = nil
      redirect_to new_session_url,
                  alert: "Your account has been disabled.",
                  status: :see_other
    end
  end

  def login(user)
    session[:current_user_id] = user.id
  end

  def logout
    session.delete(:current_user_id)
    @_current_user = nil
  end


  private

  def load_current_user
    User.find_by(id: session[:current_user_id])
  end

  def not_found
    render file: "#{ Rails.root }/public/404.html",  layout: false, status: :not_found
  end
end
