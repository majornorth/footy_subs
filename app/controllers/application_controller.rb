class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper


  def after_sign_in_path_for(resource)
    events_path
  end

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  protected

  def view_application?
    if current_user && current_user.admin
      return true
    elsif current_user
      redirect_to signup_success_path
    else
      redirect_to root_path
    end
  end

  def is_admin?
    if current_user && current_user.admin == true
      return true
    else
      return false
    end
  end

  helper_method :view_events?, :is_admin?
end