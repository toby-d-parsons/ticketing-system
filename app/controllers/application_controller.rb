class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user

  private

  def set_current_user
    if session[:user_id].present?
      Current.user = User.find_by(id: session[:user_id])
    end
  end
end
