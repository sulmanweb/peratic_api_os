# This is the base controller for all the controllers in the application.
class ApplicationController < ActionController::API
  def auth_header
    request.headers['Authorization']&.split&.last
  end

  def current_user
    Current.user = User.find_by_token_for(:auth_token, auth_header)
    @current_user ||= Current.user
  end
end
