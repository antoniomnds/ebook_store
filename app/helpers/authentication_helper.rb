module AuthenticationHelper
  # Finds the User with the ID stored in the session with the key :current_user_id.
  def current_user
    @_current_user ||= session[:current_user_id] && load_current_user
  end

  def logged_in?
    current_user.present?
  end
end
