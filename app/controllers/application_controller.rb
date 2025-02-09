class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user

  private

  def set_current_user
    Rails.logger.debug "Session (before access): #{session.inspect}"

    if session[:user_id].present?
      Rails.logger.debug "Session user_id: #{session[:user_id]}"
      Current.user = User.find_by(id: session[:user_id])
    end

    Rails.logger.debug "Session (after access): #{session.inspect}"
  end
end
