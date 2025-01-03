class SignupController < ApplicationController
  before_action :signed_in?
  allow_unauthenticated_access
  def new
  end

  private
  def signed_in?
    redirect_to root_path if authenticated?
  end
end
