class SignupController < ApplicationController
  before_action :signed_in?
  allow_unauthenticated_access
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role_id = 3 # Temp, will default to User role in future
    puts @user
    if @user.save!
      redirect_to root_path
    else
      redirect_to signup_path, status: :unprocessable_entity
    end
  end

  private
  def signed_in?
    redirect_to root_path if authenticated?
  end

  def user_params
    params.expect(user: [ :email_address, :password, :password_digest ])
  end
end
