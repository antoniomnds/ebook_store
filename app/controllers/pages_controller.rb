class PagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_current_user

  def home
  end
end
